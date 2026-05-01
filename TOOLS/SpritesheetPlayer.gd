extends Node2D

@export var spritesheet_path: String = "res://assets/pics/another-victory_spritesheet.png"
@export var h_frames: int = 8
@export var v_frames: int = 7
@export var fps: float = 10.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var _current_frame: int = 0
var _total_frames: int:
	get: return h_frames * v_frames


func _ready() -> void:
	var texture = load(spritesheet_path)
	if not texture:
		push_error("Spritesheet not found: " + spritesheet_path)
		return

	sprite.texture = texture
	sprite.region_enabled = true

	_current_frame = 0
	timer.wait_time = 1.0 / fps
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout() -> void:
	_current_frame = (_current_frame + 1) % _total_frames

	var frame_x = _current_frame % h_frames
	var frame_y = _current_frame / h_frames

	var frame_w = sprite.texture.get_width() / h_frames
	var frame_h = sprite.texture.get_height() / v_frames

	sprite.region_rect = Rect2(frame_x * frame_w, frame_y * frame_h, frame_w, frame_h)
