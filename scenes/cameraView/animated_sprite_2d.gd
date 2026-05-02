extends Sprite2D

@onready var current_animation = $AnimatedSprite2D

var current_animation_id := "default"

func _ready() -> void:
	current_animation.play(current_animation_id)
	
func change_animtaion(animation_id) -> void:
	current_animation.animation = animation_id
	current_animation.play()

#
#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#change_animtaion("new_animation")
