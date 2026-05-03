extends Sprite2D

@onready var sprite = $AnimationSprite2D

func _ready() -> void:
	sprite.play()
	
