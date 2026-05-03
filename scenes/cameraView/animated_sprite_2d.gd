extends Sprite2D

signal temp_animation_finished()

@onready var current_animation = $AnimationSprite2D
@onready var idle_timer = $IdleTimer
@onready var voice: AudioStreamPlayer = $Voice

var default_animation := "default"

var map_animation := {
	"bad": ["0_p", "0_p2"],
	"normal": ["66_p"],
	"good": ["80_p"],
	"idle": ["idle", "idle2", "idle3", "idle4", "idle5"]
}

var map_voices := {
	"bad": ["0_p", "0_p2", "0_p3"],
	"normal": ["60_p", "60_p2", "60_p3"],
	"good": ["80_p", "80_p2", "80_p3", "80_p4"],
}

var idle_start_frame := 0
var is_playing_idle := false
var just_started_idle := false

func _ready() -> void:
	print("AnimatedSprite2D ready. voice=", voice)
	current_animation.animation_finished.connect(_on_animation_finished)
	current_animation.frame_changed.connect(_on_frame_changed)
	idle_timer.timeout.connect(_on_idle_timeout)
	idle_timer.start(randf_range(30.0, 40.0))
	current_animation.play(default_animation)

func _on_animation_finished() -> void:
	if current_animation.animation != default_animation:
		current_animation.play(default_animation)
		temp_animation_finished.emit()
		is_playing_idle = false
	idle_timer.start(randf_range(30.0, 40.0))

func _on_frame_changed() -> void:
	if just_started_idle:
		just_started_idle = false
		return
	if is_playing_idle and current_animation.frame == idle_start_frame:
		current_animation.play(default_animation)
		temp_animation_finished.emit()
		is_playing_idle = false
		idle_timer.start(randf_range(30.0, 40.0))

func _on_idle_timeout() -> void:
	play_temp_animation("idle")

func play_temp_animation(animation_key: String) -> void:
	if not map_animation.has(animation_key):
		return
	var animations = map_animation[animation_key]
	var random_anim = animations[randi() % animations.size()]
	idle_start_frame = 0
	is_playing_idle = true
	just_started_idle = true
	current_animation.animation = random_anim
	current_animation.play()
	_play_voice(animation_key)

func _play_voice(animation_key: String) -> void:
	print("_play_voice called: ", animation_key)
	if not map_voices.has(animation_key):
		print("No voice mapping for: ", animation_key)
		return
	var voices = map_voices[animation_key]
	var random_voice = voices[randi() % voices.size()]
	print("Playing voice: ", random_voice)
	if voice:
		voice.stop()
		voice.stream = load(str("res://assets/audio/voices/", random_voice, ".wav"))
		voice.play()

func stop_voice() -> void:
	if voice:
		voice.stop()
