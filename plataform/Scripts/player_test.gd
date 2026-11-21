extends CharacterBody2D
# JOGADOR DE TESTE: serve só para testar obstáculos e fases
# enquanto o personagem de verdade não fica pronto.

signal died

const SPEED := 200.0
const JUMP_VELOCITY := -350.0
const GRAVITY := 900.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = Input.get_axis("ui_left", "ui_right") * SPEED
	move_and_slide()

func die() -> void:
	died.emit()
