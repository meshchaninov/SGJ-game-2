extends Node2D

@onready var clue: Control = $Clue
@onready var progress_bar: Control = $ProgressBar
@onready var attempt: Control = $Attempt
@onready var check: Control = $Check
@onready var sprite: Sprite2D = $Sprite2D
@onready var next_level: Control = $NextLevel

func _ready() -> void:
	clue.toggle_pressed.connect(_on_clue_toggle_pressed)
	check.check_pressed.connect(_on_check_pressed)

func _on_clue_toggle_pressed() -> void:
	_handle_check()

func _on_check_pressed() -> void:
	_handle_check()

func _handle_check() -> void:
	var percent = GlobalStateScene.checkWinPercent()
	progress_bar.set_percent(percent)

	GlobalStateScene.lives -= 1
	attempt.change_lives(GlobalStateScene.lives)

	if GlobalStateScene.lives == 0:
		get_node("/root/PlayerScene/Defeat").toggle_curtain()
		return

	if percent < 66:
		sprite.play_temp_animation("bad")
	elif percent < 80:
		sprite.play_temp_animation("normal")
	elif percent == 100:
		sprite.play_temp_animation("good")
		next_level.check_and_show_button()
