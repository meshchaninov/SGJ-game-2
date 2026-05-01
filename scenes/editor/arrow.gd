extends Node2D

@export var editorRow: EditorRow
@export var is_left: bool = false;

func _ready() -> void:
	$Button.update_flip(is_left)
	

func _on_button_click(is_flip: bool) -> void:
	editorRow.click.emit(is_left)
