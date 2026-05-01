## slime_body.gd
## Альтернативный вариант: вешается на RigidBody2D
## Для этого варианта создай сцену с RigidBody2D как корнем

class_name SlimeBody
extends RigidBody2D

## === PUBLIC TUNING ===
@export var ring_point_count: int = 12
@export var ring_radius: float = 40.0
@export var point_mass: float = 1.0
@export var stiffness: float = 600.0
@export var damping: float = 8.0
@export var ring_stiffness: float = 400.0
@export var ring_damping: float = 6.0

## === MOVEMENT ===
@export var move_speed: float = 250.0
@export var jump_force: float = 450.0
@export var gravity_extra: float = 200.0
@export var ground_friction: float = 0.85

## === DEBUG ===
@export var debug_draw: bool = false

## === PRIVATE ===
var _points: Array[RigidBody2D] = []
var _center_joints: Array[DampedSpringJoint2D] = []
var _ring_joints: Array[DampedSpringJoint2D] = []
var _spring_ring: Node2D
var _visual: Node2D

var _is_on_floor: bool = false
var _velocity: Vector2 = Vector2.ZERO
var _facing_direction: int = 1

## Floor check ray (для RigidBody2D у которого нет is_on_floor)
var _floor_ray: RayCast2D

func _ready() -> void:
	gravity_scale = 0.0  ## управляем gravity вручную

	## Floor ray
	_floor_ray = RayCast2D.new()
	_floor_ray.name = "FloorRay"
	_floor_ray.target_position = Vector2(0, 14)
	_floor_ray.collide_with_areas = false
	_floor_ray.collide_with_bodies = true
	add_child(_floor_ray)

	## Создаём Node2D для хранения точек и связей
	_spring_ring = Node2D.new()
	_spring_ring.name = "SpringRing"
	add_child(_spring_ring)

	_generate_ring_points()
	_setup_visual()

func _generate_ring_points() -> void:
	for i in ring_point_count:
		var angle := TAU * i / ring_point_count
		var pos := Vector2.from_angle(angle) * ring_radius

		var point := RigidBody2D.new()
		point.name = "Point%d" % i
		point.mass = point_mass
		point.gravity_scale = 0.0
		point.linear_damp = 2.0
		point.angular_damp = INF  ## lock rotation instead of fixed_rotation

		var shape := CircleShape2D.new()
		shape.radius = 3.0
		var col := CollisionShape2D.new()
		col.shape = shape
		point.add_child(col)

		point.position = pos
		point.linear_velocity = Vector2.ZERO

		_spring_ring.add_child(point)
		_points.append(point)

	## Пружины от центра к каждой точке
	for i in ring_point_count:
		var joint := DampedSpringJoint2D.new()
		joint.name = "Joint_Center_%d" % i
		joint.node_a = get_path()
		joint.node_b = _points[i].get_path()
		joint.stiffness = stiffness
		joint.damping = damping
		joint.length = ring_radius
		add_child(joint)
		_center_joints.append(joint)

	## Пружины по кольцу (соседние точки)
	for i in ring_point_count:
		var next_i := (i + 1) % ring_point_count
		var joint := DampedSpringJoint2D.new()
		joint.name = "Joint_Ring_%d_%d" % [i, next_i]
		joint.node_a = _points[i].get_path()
		joint.node_b = _points[next_i].get_path()
		joint.stiffness = ring_stiffness
		joint.damping = ring_damping
		joint.length = ring_radius * 2.0 * sin(TAU / ring_point_count / 2.0)
		_spring_ring.add_child(joint)
		_ring_joints.append(joint)

	## Cross-bracing для стабильности формы
	for i in ring_point_count:
		var cross_i := (i + ring_point_count / 2) % ring_point_count
		if cross_i > i:
			var joint := DampedSpringJoint2D.new()
			joint.name = "Joint_Cross_%d_%d" % [i, cross_i]
			joint.node_a = _points[i].get_path()
			joint.node_b = _points[cross_i].get_path()
			joint.stiffness = ring_stiffness * 0.5
			joint.damping = ring_damping
			joint.length = ring_radius * 2.0
			_spring_ring.add_child(joint)

func _setup_visual() -> void:
	_visual = Node2D.new()
	_visual.name = "SlimeVisual"
	add_child(_visual)

	var poly := Polygon2D.new()
	poly.name = "Polygon"
	poly.color = Color(0.2, 0.8, 0.3, 1.0)
	poly.polygon = _get_current_polygon()
	_visual.add_child(poly)

func _get_current_polygon() -> PackedVector2Array:
	var polygon := PackedVector2Array()
	for p in _points:
		polygon.append(p.global_position - global_position)
	return polygon

## Проверка пола через raycast
func _check_floor() -> bool:
	if _floor_ray.is_colliding():
		var collider := _floor_ray.get_collider()
		if collider is StaticBody2D or collider is CharacterBody2D:
			return true
	return false

func _physics_process(delta: float) -> void:
	## Собственная гравитация
	_velocity.y += gravity_extra * delta

	## Проверка пола
	_is_on_floor = _check_floor()

	## Движение
	_velocity.x *= ground_friction if _is_on_floor else 1.0

	## Применяем velocity
	var collision := move_and_collide(_velocity * delta)

	## Синхронизация точек кольца с центром
	_sync_ring_to_center()

	## Обновляем визуал
	_update_visual()

	if debug_draw:
		queue_redraw()

func _sync_ring_to_center() -> void:
	for i in _points.size():
		var point := _points[i]
		var angle := TAU * i / ring_point_count
		var expected_pos := Vector2.from_angle(angle) * ring_radius
		var target := expected_pos + position
		var spring_force := (target - point.position) * stiffness * 0.01
		point.apply_central_force(spring_force)

func _update_visual() -> void:
	var poly := _visual.get_node_or_null("Polygon") as Polygon2D
	if poly:
		poly.polygon = _get_current_polygon()

## === PUBLIC ===
func move(direction: float) -> void:
	_facing_direction = sign(direction) if direction != 0 else _facing_direction
	_velocity.x = direction * move_speed

func jump() -> void:
	if _is_on_floor:
		_velocity.y = -jump_force
		_apply_jump_impulse()

func _apply_jump_impulse() -> void:
	for i in _points.size():
		var angle := TAU * i / ring_point_count
		var outward := Vector2.from_angle(angle) * jump_force * 0.15
		_points[i].apply_central_impulse(outward)

func apply_impact_force(force: Vector2) -> void:
	for p in _points:
		p.apply_central_impulse(force * p.mass * 0.05)

## === DEBUG ===
func _draw() -> void:
	if not debug_draw:
		return
	for p in _points:
		draw_circle(p.position, 4.0, Color.RED)
	for i in _points.size():
		draw_line(Vector2.ZERO, _points[i].position, Color.YELLOW, 1.0)
