extends TextureButton

@onready var curtain:  = $"../.."

func skip():
	# тут заглушаем аудио
	curtain.emit_toggle()
