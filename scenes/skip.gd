extends TextureButton

@onready var curtain: Briefing = $"../.."

func skip():
	# тут заглушаем аудио
	curtain.emit_toggle()
