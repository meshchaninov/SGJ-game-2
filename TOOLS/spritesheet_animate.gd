extends AnimatedSprite2D

@export var h_frames: int = 8
@export var v_frames: int = 7
@export var fps: float = 10.0

var _total_frames: int:
	get: return h_frames * v_frames

var _current_frame: int = 0


func _ready() -> void:
	sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("default")
	sprite_frames.set_animation_loop("default", true)

	var texture = sprite_frames.get_frame("default", 0)
	# Note: assign your spritesheet texture in the inspector first
	# For now we use whatever texture is set

	# If no texture assigned, try to find it from the parent or node path
	if texture == null:
		var parent = get_parent()
		if parent and parent.has_method("texture"):
			texture = parent.texture

	# Create frames from spritesheet
	for i in _total_frames:
		var frame_region = Rect2(
			(i % h_frames) * 246,  # frame width
			(i / h_frames) * 246,  # frame height
			246,  # width
			246   # height
		)
		sprite_frames.add_frame("default", texture, 1.0 / fps)

	play("default")
