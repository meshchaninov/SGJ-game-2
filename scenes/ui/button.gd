extends Area2D

@export var is_flip: bool = false;

var test = false

var is_hovered = false
var is_click = false

@export var mainTexture: Texture2D
@export var clickTexture: Texture2D
@export var hoverTexture: Texture2D
@export var picture_height: float = 54.0

@onready var pic: Sprite2D = $Picture
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal click(is_flip: bool)

func _ready() -> void:
	pic.flip_h = is_flip
	pic.texture =(mainTexture)
	_apply_picture_height()
	_update_collision_shape_from_picture()
	
func update_flip(value: bool):
	is_flip = value
	pic.flip_h = is_flip


func _apply_picture_height() -> void:
	if pic.texture == null:
		return
	if picture_height <= 0.0:
		return

	var texture_height := pic.texture.get_size().y
	if texture_height <= 0.0:
		return

	var target_scale := picture_height / texture_height
	pic.scale = Vector2(target_scale, target_scale)


func _update_collision_shape_from_picture() -> void:
	if pic.texture == null:
		return

	var rect_shape := collision_shape.shape as RectangleShape2D

	if rect_shape == null:
		return

	var texture_size: Vector2 = pic.texture.get_size()
	var scaled_size := Vector2(texture_size.x * abs(pic.scale.x), texture_size.y * abs(pic.scale.y))
	var top_left := pic.position
	if pic.centered:
		top_left -= scaled_size / 2.0

	rect_shape.size = scaled_size
	collision_shape.position = top_left + (scaled_size / 2.0)


func _on_mouse_entered() -> void:
	is_hovered = true
	if (!is_click):
		pic.texture = (hoverTexture)
		_apply_picture_height()
		_update_collision_shape_from_picture()

func _on_mouse_exited() -> void:
	is_hovered = false
	is_click = false
	pic.texture =(mainTexture)
	_apply_picture_height()
	_update_collision_shape_from_picture()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(Input.is_action_just_pressed("L_BTN") && !is_click):
		is_click = true
		pic.texture =(clickTexture)
		_apply_picture_height()
		_update_collision_shape_from_picture()
		click.emit(is_flip)
	if(event.is_action_released("L_BTN")):
		is_click = false
		if (is_hovered):
			pic.texture = (hoverTexture)
		else:
			pic.texture = (mainTexture)
		_apply_picture_height()
		_update_collision_shape_from_picture()
