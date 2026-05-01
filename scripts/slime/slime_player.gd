## slime_player.gd
## Вешается на тот же узел что и slime_body.gd
## Управляет вводом и движением слизи.

class_name SlimePlayer
extends RigidBody2D

@export var slime: SlimeBody        ## ссылка на SlimeBody (можно привязать через Inspector)

@export var move_speed: float = 250.0
@export var jump_force: float = 450.0

var _move_input: float = 0.0

func _ready() -> void:
	## Если slime не привязан явно — ищем в детях
	if slime == null:
		slime = get_node_or_null(".") as SlimeBody

func _physics_process(delta: float) -> void:
	## Считываем ввод
	_move_input = Input.get_axis("ui_left", "ui_right")

	## Если slime привязан — управляем им, иначе управляем напрямую
	if slime:
		slime.move(_move_input)
		if Input.is_action_just_pressed("ui_accept"):
			slime.jump()
		slime._velocity = slime._velocity  ## DEBUG: синхронизируем velocity

	## Прямое управление (если нет slime)
	apply_central_force(Vector2(_move_input * move_speed * 10, 0))
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		apply_central_impulse(Vector2(0, -jump_force))
