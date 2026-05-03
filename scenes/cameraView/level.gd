extends Control

signal lvl_changed(lives: int)

@onready var lvl1 = $lvl1
@onready var lvl2 = $lvl2
@onready var lvl3 = $lvl3

var current_lvl := 1

func _ready() -> void:
	change_lvl(current_lvl)
	
func change_lvl(lvl) -> void:
	var life_texture = load("res://assets/pics/ui/arrow/attempt_life.png")
	var no_life_texture = load("res://assets/pics/ui/arrow/attempt_no_life.png")
	
	current_lvl = lvl
	lvl_changed.emit(lvl)

	if lvl == 1:
		lvl1.texture = life_texture
		lvl2.texture = no_life_texture
		lvl3.texture = no_life_texture
	elif lvl == 2:
		lvl1.texture = life_texture
		lvl2.texture = life_texture
		lvl3.texture = no_life_texture
	elif lvl == 3:
		lvl1.texture = life_texture
		lvl2.texture = life_texture
		lvl3.texture = life_texture
