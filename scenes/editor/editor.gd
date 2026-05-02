extends Node2D

func updateVisibleParts():
	GlobalScene.true_blob_state.filter

func updateTextureParts():
	$blobAndParts/EditorHead.update_texture()
	$blobAndParts/EditorEye.update_texture()
	$blobAndParts/EditorMouth.update_texture()
	$blobAndParts/EditorHands.update_texture()
	$blobAndParts/EditorCloth.update_texture()
	

#func _ready() -> void:
	# $EditorRow_1.max_index = globalScene.max_parts[0]
