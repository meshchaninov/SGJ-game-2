extends TextureButton

@onready var curtain: Curtain = $"../.."

func skip():
	# тут заглушаем аудио
	curtain.emit_toggle()
