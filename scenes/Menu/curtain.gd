extends CanvasLayer
class_name Curtain

@onready var curtain: ColorRect = $ColorRect

@export var defaultOpen = false

var is_closed := false
var is_animating := false
var tween: Tween

var hidden_y := 0.0
var shown_y := 0.0

signal toggle

func emit_toggle():
	toggle.emit()

func _ready() -> void:
	hidden_y = curtain.position.y
	shown_y = 0.0
	if(defaultOpen):
		is_closed = defaultOpen # пиздец
		var xPos = curtain.position[0]
		curtain.set_position(Vector2(xPos, shown_y))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_curtain()
		get_viewport().set_input_as_handled()
		curtain.set

func toggle_curtain() -> void:
	if is_animating:
		return

	is_animating = true

	if tween:
		tween.kill()

	tween = create_tween()
	tween.finished.connect(_on_tween_finished)

	if is_closed:
		tween.tween_property(curtain, "position:y", hidden_y, 0.32) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_IN)
		is_closed = false
	else:
		tween.tween_property(curtain, "position:y", 0.0, 0.36) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)
		tween.tween_property(curtain, "position:y", shown_y, 0.12) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_OUT)
		is_closed = true

func _on_tween_finished() -> void:
	is_animating = false
