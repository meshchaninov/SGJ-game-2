extends Node

@onready var menu_music: AudioStreamPlayer = $"../MenuMusic"
@onready var game_music: AudioStreamPlayer = $"../GameMusic"

var game_started := false

func _ready() -> void:
	print("Menu ready. menu_music=", menu_music, " game_music=", game_music)
	if menu_music and game_music:
		menu_music.stream = preload("res://assets/audio/menu.mp3")
		game_music.stream = preload("res://assets/audio/game.mp3")
		menu_music.play()
	else:
		print("Audio nodes NOT found!")

func play_game_music() -> void:
	if game_started:
		return
	game_started = true
	GlobalScene.reset_game()
	if menu_music and game_music:
		game_music.play()
		menu_music.stop()
