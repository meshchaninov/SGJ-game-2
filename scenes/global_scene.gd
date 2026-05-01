extends Node2D


var current_blob_state = [1, 2, 3, 4, 5]
var true_blob_state = [1, 1, 1, null, null]

static const PARTS = {
	'EYE_1': 
}

func set_true_blob_state(newState: Array) -> void:
	true_blob_state = newState

func set_current_blob_state(newState: Array) -> void:
	true_blob_state = newState
