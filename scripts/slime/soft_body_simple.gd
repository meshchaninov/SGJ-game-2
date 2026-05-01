## soft_body_simple.gd
## Soft body via direct spring forces — NO DampedSpringJoint2D
## Points attracted to center + ring forces + damping

class_name SoftBodySimple
extends Node2D

## === TUNING ===
@export var point_count: int = 12
@export var radius: float = 50.0

## Spring forces
@export var center_stiffness: float = 150.0   ## притяжение к центру
@export var center_damping: float = 8.0        ## гашение колебаний
@export var ring_stiffness: float = 60.0       ## связь по кольцу
@export var ring_damping: float = 6.0

## Visual
@export var visual_color: Color = Color(0.3, 0.85, 0.3, 1.0)
@export var use_sprite: bool = false
@export var sprite_path: String = ""

## Movement
@export var move_speed: float = 250.0
@export var jump_force: float = 450.0
@export var gravity: float = 800.0
@export var ground_friction: float = 0.85

## Debug
@export var debug: bool = false

## === INTERNAL ===
var _points: Array[RigidBody2D] = []
var _kinematic_body: CharacterBody2D
var _polygon: Polygon2D
var _sprite: Sprite2D

var _move_dir: float = 0.0
var _velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	_setup_kinematic()
	_setup_points()
	_setup_visual()

func _setup_kinematic() -> void:
	_kinematic_body = CharacterBody2D.new()
	_kinematic_body.name = "Center"

	var cs := CircleShape2D.new()
	cs.radius = 10.0
	var col := CollisionShape2D.new()
	col.shape = cs
	_kinematic_body.add_child(col)

	var ray := RayCast2D.new()
	ray.name = "FloorRay"
	ray.target_position = Vector2(0, 14)
	ray.collide_with_bodies = true
	_kinematic_body.add_child(ray)

	add_child(_kinematic_body)

func _setup_points() -> void:
	for i in point_count:
		var angle := TAU * i / point_count
		var pos := Vector2.from_angle(angle) * radius

		var point := RigidBody2D.new()
		point.name = "P%d" % i
		point.mass = 1.0
		point.gravity_scale = 0.0
		point.linear_damp = 0.0  ## мы сами гасим через damping
		point.angular_damp = INF
		point.position = pos

		var cs := CircleShape2D.new()
		cs.radius = 3.0
		var col := CollisionShape2D.new()
		col.shape = cs
		point.add_child(col)

		add_child(point)
		_points.append(point)

func _setup_visual() -> void:
	if use_sprite and sprite_path != "":
		_sprite = Sprite2D.new()
		_sprite.name = "Sprite"
		var tex := load(sprite_path) as Texture2D
		if tex:
			_sprite.texture = tex
			var tex_size := tex.get_size() if tex.has_method("get_size") else Vector2(100, 100)
			var max_dim := maxf(tex_size.x, tex_size.y)
			var scale_factor := (radius * 2.0) / max_dim if max_dim > 0.0 else 1.0
			_sprite.scale = Vector2(scale_factor, scale_factor)
		add_child(_sprite)
	else:
		_polygon = Polygon2D.new()
		_polygon.name = "Polygon"
		_polygon.color = visual_color
		_polygon.polygon = _get_polygon()
		add_child(_polygon)

func _physics_process(delta: float) -> void:
	## === INPUT ===
	_move_dir = Input.get_axis("ui_left", "ui_right")

	## === KINEMATIC BODY PHYSICS ===
	_velocity.y += gravity * delta
	_velocity.x = _move_dir * move_speed

	if _kinematic_body.is_on_floor():
		_velocity.x *= ground_friction

	if Input.is_action_just_pressed("ui_accept") and _kinematic_body.is_on_floor():
		_velocity.y = -jump_force
		_apply_jump_wobble()

	_kinematic_body.velocity = _velocity
	_kinematic_body.move_and_slide()

	## === SOFT BODY FORCES ===
	_apply_spring_forces(delta)

	## === VISUAL ===
	_update_visual()

	if debug:
		queue_redraw()

func _apply_spring_forces(delta: float) -> void:
	var center_pos := _kinematic_body.position

	## 1) Притяжение точек к центру
	for i in _points.size():
		var point := _points[i]
		var angle := TAU * i / point_count
		var target := center_pos + Vector2.from_angle(angle) * radius

		## Spring force: F = -k * (x - target) - d * v
		var displacement := point.position - target
		var spring_force := displacement * (-center_stiffness)
		var damping_force := point.linear_velocity * (-center_damping)
		point.apply_central_force(spring_force + damping_force)

	## 2) Связи по кольцу (соседние точки)
	for i in _points.size():
		var point := _points[i]
		var next_i := (i + 1) % _points.size()
		var next_point := _points[next_i]

		var chord_len := radius * 2.0 * sin(PI / point_count)
		var diff := next_point.position - point.position
		var current_len := diff.length()
		if current_len > 0.001:
			var extension := current_len - chord_len
			var dir := diff / current_len
			var force := dir * extension * ring_stiffness
			## damping along the connection
			var rel_vel := next_point.linear_velocity - point.linear_velocity
			var damp := rel_vel.dot(dir) * ring_damping
			force += dir * damp

			point.apply_force(force)
			next_point.apply_force(-force)

	## 3) Cross-bracing (через-через) — стабильность формы
	for i in _points.size():
		var point := _points[i]
		var cross_i := (i + point_count / 2) % point_count
		if cross_i > i:
			var cross_point := _points[cross_i]
			var diag_len := radius * 2.0 * sin(PI / point_count * 2.0)
			var diff := cross_point.position - point.position
			var current_len := diff.length()
			if current_len > 0.001:
				var extension := current_len - diag_len
				var dir := diff / current_len
				var force := dir * extension * ring_stiffness * 0.5
				var rel_vel := cross_point.linear_velocity - point.linear_velocity
				var damp := rel_vel.dot(dir) * ring_damping * 0.5
				force += dir * damp

				point.apply_force(force)
				cross_point.apply_force(-force)

func _apply_jump_wobble() -> void:
	for i in _points.size():
		var angle := TAU * i / point_count
		_points[i].apply_central_impulse(Vector2.from_angle(angle) * jump_force * 0.08)

func _update_visual() -> void:
	if _polygon:
		_polygon.polygon = _get_polygon()
	if _sprite:
		_sprite.position = _kinematic_body.position
		_sprite.rotation = _kinematic_body.rotation

func _get_polygon() -> PackedVector2Array:
	var poly := PackedVector2Array()
	for p in _points:
		poly.append(p.position)
	return poly

## === DEBUG ===
func _draw() -> void:
	if not debug:
		return
	for p in _points:
		draw_circle(p.position, 4.0, Color.RED)
	for i in _points.size():
		var next_i := (i + 1) % _points.size()
		draw_line(_points[i].position, _points[next_i].position, Color.YELLOW, 1.5)
	draw_line(_kinematic_body.position, _kinematic_body.position, Color.BLUE, 0)  ## center dot
	draw_circle(_kinematic_body.position, 6.0, Color.BLUE)

## === PUBLIC ===
func get_center_body() -> CharacterBody2D:
	return _kinematic_body

func apply_impact(direction: Vector2, strength: float = 1.0) -> void:
	for p in _points:
		p.apply_central_impulse(direction * strength * 0.1)
