extends Node2D

func updateVisibleParts():
	GlobalScene.true_blob_state.filter

func updateTextureParts():
	$blobAndParts/EditorHead.refreshRow()
	$blobAndParts/EditorEye.refreshRow()
	$blobAndParts/EditorMouth.refreshRow()
	$blobAndParts/EditorHands.refreshRow()
	$blobAndParts/EditorCloth.refreshRow()
	

#func _ready() -> void:
	# $EditorRow_1.max_index = globalScene.max_parts[0]
