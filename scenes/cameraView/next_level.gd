extends Control

@onready var button: TextureButton = $NextLevelButton

func _ready() -> void:
	button.hide()
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	get_node("/root/PlayerScene/Win").toggle_curtain()

func show_button() -> void:
	button.show()

func hide_button() -> void:
	button.hide()

func check_and_show_button() -> void:
	if GlobalStateScene.checkWinPercent() == 100:
		show_button()
