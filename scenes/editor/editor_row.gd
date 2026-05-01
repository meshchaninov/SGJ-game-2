extends Node2D

class_name  EditorRow
#@export var max_index: int
#@export var paths_array: Array[String]

@export var part_index: int
@export var sprite: Sprite2D

signal click(is_left: bool)


var paths_array: Array[String] 

func _ready() -> void:
	paths_array = GlobalStateScene.PARTS_PER_ROW[part_index]
	update_texture()

func update_texture():
	var current = get_current_index()
	sprite.texture = getTexture(paths_array[current])
	
func get_max_index() -> int: 
	return GlobalStateScene.max_parts[part_index]
	
func get_current_index() -> int: 
	return GlobalStateScene.current_blob_state[part_index]

func getTexture(str: String) -> Texture2D:
	var texture = load(str)
	return texture

func _on_click(is_left: bool) -> void:
	print('ON CLICK')
	var current = get_current_index()
	var max = get_max_index()
	var next_index: int
	var prev_index: int

	if(current == max):
		next_index = 0
	else:
		next_index = current + 1	
		
	if(current == 0):
		prev_index = max
	else:
		prev_index = current - 1
	
	if(is_left):
		GlobalScene.set_current_blob_state_part(prev_index, part_index)
	else:
		GlobalScene.set_current_blob_state_part(next_index, part_index)
	
	update_texture()
