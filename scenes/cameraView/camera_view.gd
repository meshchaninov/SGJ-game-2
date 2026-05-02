extends Node2D

@onready var clue: Control = $Clue
@onready var progress_bar: Control = $ProgressBar
@onready var attempt: Control = $Attempt
@onready var check: Control = $Check

func _ready() -> void:
	clue.toggle_pressed.connect(_on_clue_toggle_pressed)
	check.check_pressed.connect(_on_check_pressed)

func _on_clue_toggle_pressed() -> void:
	var percent = GlobalStateScene.checkWinPercent()
	progress_bar.set_percent(percent)

	GlobalStateScene.lives -= 1
	attempt.change_lives(GlobalStateScene.lives)

func _on_check_pressed() -> void:
	var percent = GlobalStateScene.checkWinPercent()
	progress_bar.set_percent(percent)

	GlobalStateScene.lives -= 1
	attempt.change_lives(GlobalStateScene.lives)
