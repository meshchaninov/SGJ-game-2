extends Node2D

#@export var max_index: int
#@export var paths_array: Array[String]

@export var part_index: int
@export var sprite: Sprite2D


var paths_array: Array[String] 


func _ready() -> void:
	print(part_index)
	print(GlobalStateScene.PARTS_PER_ROW)
	paths_array = GlobalStateScene.PARTS_PER_ROW[part_index]
	sprite.texture = getTexture(paths_array[0])


func get_max_index() -> int: 
	return GlobalStateScene.max_parts[part_index]

func getTexture(str: String) -> Texture2D:
	var texture = load(str)
	return texture

func _on_button_right_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		print('right click')


func _on_button_left_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		print('left click')
