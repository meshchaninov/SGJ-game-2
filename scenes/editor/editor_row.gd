extends Node2D

class_name  EditorRow
#@export var max_index: int
#@export var paths_array: Array[String]

@export var part_index: int
@export var sprite: Sprite2D
@onready var scene = $"."

signal click(is_left: bool)

static var part_names = ['head', 'eye', 'mouth', 'hand', 'cloth']

var paths_array: Array[String]
var pathName: String

func _ready() -> void:
	pathName = part_names[part_index]
	refreshRow()
	update_texture()
	
# Обнуляет и показывает/скрывает часть при обновлении true state
func refreshRow():
	var toHide = get_max_index() == null
	if(toHide):
		GlobalScene.set_current_blob_state_part(0, part_index)
	update_texture()
	sprite.visible = !toHide
	scene.visible = !toHide
	
	

func update_texture():
	if(get_max_index() == null):
		GlobalScene.set_current_blob_state_part(0, part_index)
	var currentIndex  = get_current_index()
	var texture: Texture2D
	match pathName:
		'head':
			texture = GlobalScene.getPartHead(currentIndex)
		'eye':
			texture = GlobalScene.getPartEye(currentIndex)
		'mouth':
			texture = GlobalScene.getPartMouth(currentIndex)
		'cloth':
			texture = GlobalScene.getPartCloth(currentIndex)
		'hand':
			texture = GlobalScene.getPartHand(currentIndex)
	print(pathName)
	print(currentIndex)
	print(texture)
	sprite.texture = texture
	
func get_max_index(): 
	return GlobalStateScene.max_parts[part_index]
	
func get_current_index(): 
	return GlobalStateScene.current_blob_state[part_index]

func getTexture(str: String) -> Texture2D:
	var texture = load(str)
	return texture

func _on_click(is_left: bool) -> void:
	print('ON CLICK')
	var current = get_current_index()
	var max = get_max_index()
	if(max == -1):
		return
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
