extends HSlider

func _ready() -> void:
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	value_changed.connect(_on_value_changed)
	value = 0.5
	_set_master_volume(0.5)

func _on_value_changed(val: float) -> void:
	_set_master_volume(val)

func _set_master_volume(val: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index >= 0:
		if val <= 0.0:
			AudioServer.set_bus_mute(bus_index, true)
		else:
			AudioServer.set_bus_mute(bus_index, false)
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(val))
