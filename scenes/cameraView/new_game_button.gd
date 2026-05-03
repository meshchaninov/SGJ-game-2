extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	GlobalStateScene.next_level(true)
	var root = get_tree().root
	var defeat = root.get_node_or_null("PlayerScene/Defeat")
	if defeat:
		defeat.toggle_curtain()
