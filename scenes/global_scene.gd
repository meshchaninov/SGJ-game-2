extends Node2D


var current_blob_state = [1, 2, 3, 4, 5]
var true_blob_state = [1, 1, 1, null, null]

static var PARTS = {
	'EYE_1': "res://assets/pics/blob/parts/eye/1.png",
	'EYE_2': "res://assets/pics/blob/parts/eye/2.png"
}

func set_true_blob_state(newState: Array) -> void:
	true_blob_state = newState

func set_current_blob_state(newState: Array) -> void:
	true_blob_state = newState
