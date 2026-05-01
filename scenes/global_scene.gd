extends Node2D
class_name GlobalScene


static var current_blob_state = [0, 0, 0, 0, 0]
static var true_blob_state = [1, 1, 1, null, null]

# Тут показывается элемент массива до которого мы имеем доступ в части
# если -1 то часть недоступна
static var max_parts = [1, -1, -1 ,-1 ,-1]

# тут прост для удобство адреса всех пикч
static var PARTS = {
	'EYE_1': "res://assets/pics/blob/parts/eye/1.png",
	'EYE_2': "res://assets/pics/blob/parts/eye/2.png"
}

# здесь показываются части, которые доступны будут при максимальной прокачке
static var PARTS_1: Array[String] = [PARTS['EYE_1'], PARTS['EYE_2']]

static var PARTS_PER_ROW = {
	0: PARTS_1
}

static func set_true_blob_state(newState: Array) -> void:
	true_blob_state = newState

static func set_current_blob_state_part(value: int, part_index: int) -> void:
	current_blob_state[part_index] =  value
	
	
static func set_current_blob_state(newState: Array) -> void:
	true_blob_state = newState
