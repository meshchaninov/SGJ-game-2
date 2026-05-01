extends Node2D


var current_blob_state = [1, 2, 3, 4, 5]
var true_blob_state = [1, 1, 1, null, null]

# Тут показывается элемент массива до которого мы имеем доступ в части
# если -1 то часть недоступна
var max_parts = [1, -1, -1 ,-1 ,-1]

var PARTS = {
	'EYE_1': "res://assets/pics/blob/parts/eye/1.png",
	'EYE_2': "res://assets/pics/blob/parts/eye/2.png"
}

# здесь показываются части, которые доступны будут при максимальной прокачке
var PARTS_1 = [PARTS['EYE_1'], PARTS['EYE_2']]

func set_true_blob_state(newState: Array) -> void:
	true_blob_state = newState

func set_current_blob_state(newState: Array) -> void:
	true_blob_state = newState
