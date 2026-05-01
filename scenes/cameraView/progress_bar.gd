extends Control

@onready var bar: ProgressBar = $ProgressBar
@onready var label: Label = $PercentLabel


var value_tween: Tween
var label_tween: Tween
var shake_tween: Tween

var target_value := 0.0
var displayed_percent: int

func _ready() -> void:
	bar.min_value = 0
	bar.max_value = 100	
	bar.value = target_value
	label.pivot_offset = label.size * 0.5
	displayed_percent = target_value
	_update_visuals(0)
	
func get_current() -> float:
	return target_value

func set_percent(target_percent: float) -> void:
	target_percent = clamp(target_percent, 0.0, 100.0)

	if value_tween:
		value_tween.kill()

	var old_value := bar.value
	var growing := target_percent > old_value

	value_tween = create_tween().bind_node(self)
	value_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	value_tween.tween_method(_update_visuals, old_value, target_percent, 0.5)

	if growing:
		_play_label_pop()
		_play_label_shake()

func _update_visuals(v: float) -> void:
	bar.value = v
	label.text = "%d%%" % int(round(v))
	_apply_bar_color(v)

func _apply_bar_color(v: float) -> void:
	var color: Color

	if v <= 50.0:
		var t := v / 50.0
		color = Color.RED.lerp(Color.YELLOW, t)
	else:
		var t := (v - 50.0) / 50.0
		color = Color.YELLOW.lerp(Color.GREEN, t)

	# Для обычного ProgressBar со StyleBoxFlat
	var fg_style := bar.get_theme_stylebox("fill")
	if fg_style is StyleBoxFlat:
		var style := fg_style.duplicate()
		style.bg_color = color
		bar.add_theme_stylebox_override("fill", style)
		
func _play_label_pop() -> void:
	if label_tween:
		label_tween.kill()

	label.scale = Vector2.ONE
	label_tween = create_tween().bind_node(self)
	label_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.tween_property(label, "scale", Vector2(1.90, 1.90), 0.30)
	label_tween.tween_property(label, "scale", Vector2.ONE, 0.1)

func _play_label_shake() -> void:
	if shake_tween:
		shake_tween.kill()

	var start_pos := label.position

	shake_tween = create_tween().bind_node(self)
	shake_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	shake_tween.tween_property(label, "position", start_pos + Vector2(2, -1), 0.04)
	shake_tween.tween_property(label, "position", start_pos + Vector2(-2, 1), 0.04)
	shake_tween.tween_property(label, "position", start_pos + Vector2(1, 0), 0.04)
	shake_tween.tween_property(label, "position", start_pos, 0.04)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var v := bar.value
		var new_val := v + 25
		if new_val > 100:
			set_percent(0)
		else:
			set_percent(new_val)
