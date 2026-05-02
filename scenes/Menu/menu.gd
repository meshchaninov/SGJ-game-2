extends Control

@onready var menu = $"."
var is_closed = false
var is_process = false

enum Event {
	Close,
	Open,
	None
}

var is_ingame = false
var _size: Vector2
var event = Event.None

var speed = 1400;

# да, я ленивое говно
var height = 1024

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed('MENU')):
		if(event == Event.Close):
			event = Event.Open
		elif(event == Event.Open):
			event = Event.Close
		else:
			if(is_closed):
				event = Event.Open
			else:
				event = Event.Close

	if(event == Event.Close):
		close(delta)
	if(event == Event.Open):
		open(delta)
		


func open(delta: float):
	var yPos = menu.position[1]
	var nextPos = menu.position[1] + delta*speed
	if(nextPos > 0):
		nextPos = 0
		
	if(nextPos == 0):
		is_process = false
		is_closed = false
		event = Event.None
	menu.set_position(Vector2(menu.position[0], nextPos))
	
func close(delta: float):
	
	var yPos = menu.position[1]
	var nextPos = menu.position[1] - delta*speed
	if(nextPos < -height):
		nextPos = -height
		
	if(nextPos == -height):
		is_closed = true
		is_process = false
		event = Event.None
	menu.set_position(Vector2(menu.position[0], nextPos))

func _on_close_pressed() -> void:
	if (event != Event.Close):
		event = Event.Close
		is_process = true

func _on_open_pressed() -> void:
	if (event != Event.Open):
		event = Event.Open
		is_process = true
