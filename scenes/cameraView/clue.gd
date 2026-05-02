extends Control

signal toggle_pressed()

@onready var board: Control = $Board
@onready var toggle_handle: Control = $Board/ToggleHandle

@onready var clue_1 = $Board/RichTextLabel
@onready var clue_2 = $Board/RichTextLabel2
@onready var clue_3 = $Board/RichTextLabel3
@onready var clue_4 = $Board/RichTextLabel4

var tween: Tween
var clue_width := 240.0
var current_clue_id := 0

var closed_x := 0.0
var peek_offset := 40.0

var is_open := false
var is_hovered := false

func _ready() -> void:
	toggle_handle.mouse_filter = Control.MOUSE_FILTER_STOP
	toggle_handle.custom_minimum_size = Vector2(24, board.size.y)


	toggle_handle.mouse_entered.connect(_on_handle_mouse_entered)
	toggle_handle.mouse_exited.connect(_on_handle_mouse_exited)
	toggle_handle.gui_input.connect(_on_handle_gui_input)

	board.position.x = closed_x
	
	if current_clue_id == 0:
		board.hide()
		return

func set_current_clue_id(clue_id) -> void:
	current_clue_id = clue_id

func set_clue_text(clue_id, text) -> void:
	if clue_id == 1:
		clue_1.text = text
	elif clue_id == 2:
		clue_2.text = text
	elif clue_id == 3:
		clue_3.text = text
	elif clue_id == 4:
		clue_4.text = text
	
func _move_board(target_x: float, duration: float, ease_type: Tween.EaseType) -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(board, "position:x", target_x, duration) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(ease_type)

func _get_peek_x() -> float:
	return closed_x - peek_offset

func _get_open_x(clue_id: int) -> float:
	return -clue_width * float(clue_id)

func open_to_clue(clue_id) -> void:
	current_clue_id = clue_id

	if current_clue_id == 0:
		board.hide()
		return

	board.show()
	is_open = true
	_move_board(_get_open_x(current_clue_id), 0.28, Tween.EASE_OUT)

func close_clue() -> void:
	is_open = false
	if is_hovered:
		_move_board(_get_peek_x(), 0.18, Tween.EASE_IN)
	else:
		_move_board(closed_x, 0.22, Tween.EASE_IN)

func _on_handle_mouse_entered() -> void:
	is_hovered = true
	if not is_open:
		_move_board(_get_peek_x(), 0.18, Tween.EASE_OUT)

func _on_handle_mouse_exited() -> void:
	is_hovered = false
	if not is_open:
		_move_board(closed_x, 0.18, Tween.EASE_IN)

func _on_handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_pressed.emit()
		if is_open:
			close_clue()
		else:
			open_to_clue(current_clue_id)
