extends CanvasLayer

@onready var curtain: TextureRect = $ColorRect

@export var defaultOpen = false

var is_animating := false
var tween: Tween

var hidden_y := 0.0
var shown_y := -1024.0

signal toggle

func emit_toggle():
	toggle.emit()

func _ready() -> void:
	if defaultOpen:
		curtain.position.y = shown_y

func _on_tween_finished() -> void:
	is_animating = false

func flash_curtain() -> void:
	if is_animating:
		return

	is_animating = true

	if tween:
		tween.kill()

	tween = create_tween()
	tween.finished.connect(_on_flash_down)
	tween.tween_property(curtain, "position:y", hidden_y, 0.36) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

func _on_flash_down() -> void:
	await get_tree().create_timer(0.4).timeout
	tween = create_tween()
	tween.finished.connect(_on_flash_finished)
	tween.tween_property(curtain, "position:y", shown_y, 0.36) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)

func _on_flash_finished() -> void:
	is_animating = false
