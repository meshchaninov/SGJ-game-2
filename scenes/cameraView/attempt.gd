extends Control

signal lives_changed(lives: int)

@onready var life_1 = $Life
@onready var life_2 = $Life2
@onready var life_3 = $Life3
@onready var life_4 = $Life4
@onready var life_5 = $Life5
@onready var life_6 = $Life6
@onready var life_7 = $Life7
@onready var life_8 = $Life8
@onready var life_9 = $Life9
@onready var life_10 = $Life10


var current_lives := 10

func _ready() -> void:
	change_lives(current_lives)
	
func change_lives(lives) -> void:
	var life_texture = load("res://assets/pics/ui/arrow/attempt_life.png")
	var no_life_texture = load("res://assets/pics/ui/arrow/attempt_no_life.png")
	
	current_lives = lives
	lives_changed.emit(lives)

	if lives == 10:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = life_texture
		life_6.texture = life_texture
		life_7.texture = life_texture
		life_8.texture = life_texture
		life_9.texture = life_texture
		life_10.texture = life_texture
	elif lives == 9:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = life_texture
		life_6.texture = life_texture
		life_7.texture = life_texture
		life_8.texture = life_texture
		life_9.texture = life_texture
		life_10.texture = no_life_texture
	elif lives == 8:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = life_texture
		life_6.texture = life_texture
		life_7.texture = life_texture
		life_8.texture = life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 7:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = life_texture
		life_6.texture = life_texture
		life_7.texture = life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 6:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = life_texture
		life_6.texture = life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 5:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = life_texture
		life_6.texture = no_life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 4:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = life_texture
		life_5.texture = no_life_texture
		life_6.texture = no_life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 3:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = life_texture
		life_4.texture = no_life_texture
		life_5.texture = no_life_texture
		life_6.texture = no_life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 2:
		life_1.texture = life_texture
		life_2.texture = life_texture
		life_3.texture = no_life_texture
		life_4.texture = no_life_texture
		life_5.texture = no_life_texture
		life_6.texture = no_life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 1:
		life_1.texture = life_texture
		life_2.texture = no_life_texture
		life_3.texture = no_life_texture
		life_4.texture = no_life_texture
		life_5.texture = no_life_texture
		life_6.texture = no_life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
	elif lives == 0:
		life_1.texture = no_life_texture
		life_2.texture = no_life_texture
		life_3.texture = no_life_texture
		life_4.texture = no_life_texture
		life_5.texture = no_life_texture
		life_6.texture = no_life_texture
		life_7.texture = no_life_texture
		life_8.texture = no_life_texture
		life_9.texture = no_life_texture
		life_10.texture = no_life_texture
		
		
		
		
