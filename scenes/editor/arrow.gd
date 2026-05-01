extends Area2D

@export var editorRow: EditorRow
#var part_index: int
@export var is_left: bool = false;

var is_hovered = false
var is_click = false

static var mainTexture = "res://assets/pics/ui/arrow/main.png"
static var clickTexture= "res://assets/pics/ui/arrow/click.png"
static var hoverTexture = "res://assets/pics/ui/arrow/hover.png"

func _ready() -> void:
	if is_left:
		$Arrow.flip_h = true


func _on_mouse_entered() -> void:
	is_hovered = true
	if (!is_click):
		$Arrow.texture = load(hoverTexture)

func _on_mouse_exited() -> void:
	is_hovered = false
	is_click = false
	$Arrow.texture =load(mainTexture)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(Input.is_action_just_pressed("L_BTN") && !is_click):
		is_click = true
		$Arrow.texture =load(clickTexture)
		editorRow.click.emit(is_left)
	if(event.is_action_released("L_BTN")):
		is_click = false
		if (is_hovered):
			$Arrow.texture = load(hoverTexture)
		else:
			$Arrow.texture = load(mainTexture)
