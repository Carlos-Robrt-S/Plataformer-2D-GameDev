extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_pulando: bool
var is_caindo: bool


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if velocity.y > 0:
		is_pulando = true
		is_caindo = false
	elif velocity.y < 0:
		is_pulando = false
		is_caindo = true
	else:
		is_pulando = false
		is_caindo = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_pulando or is_caindo:
		sprite.play("pular")
	elif velocity.x != 0:
		sprite.play("correr")
	else:
		sprite.play("idle")

	move_and_slide()
