extends Node

@onready var curtain: ColorRect = $Curtain/ColorRect
@onready var menu_music: AudioStreamPlayer = $"../MenuMusic"
@onready var game_music: AudioStreamPlayer = $"../GameMusic"

var is_closed := true
var is_animating := false
var tween: Tween

var hidden_y := 0.0
var shown_y := 0.0

func _ready() -> void:
	hidden_y = curtain.position.y
	shown_y = 0.0
	if menu_music and game_music:
		menu_music.stream = preload("res://assets/audio/menu.mp3")
		game_music.stream = preload("res://assets/audio/game.mp3")
		game_music.play()
signal toggle

func toggle_curtain() -> void:
	if is_animating:
		return

	is_animating = true

	if tween:
		tween.kill()

	tween = create_tween()
	tween.finished.connect(_on_tween_finished)

	if is_closed:
		tween.tween_property(curtain, "position:y", shown_y, 0.36) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)
		tween.tween_property(curtain, "position:y", shown_y, 0.12) \
			.set_trans(Tween.TRANS_BACK) \
			.set_ease(Tween.EASE_OUT)
		is_closed = false
	else:
		tween.tween_property(curtain, "position:y", hidden_y, 0.32) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_IN)
		is_closed = true

func _on_tween_finished() -> void:
	is_animating = false
	if not menu_music or not game_music:
		return
	if is_closed:
		menu_music.play()
		game_music.stop()
	else:
		game_music.play()
		menu_music.stop()
