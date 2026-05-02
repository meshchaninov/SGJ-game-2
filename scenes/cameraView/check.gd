extends Control

signal check_pressed

@onready var check_button: TextureButton = $CheckButton

func _ready() -> void:
	check_button.pressed.connect(_on_check_button_pressed)

func _on_check_button_pressed() -> void:
	check_pressed.emit()
