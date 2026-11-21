extends CharacterBody2D

signal died

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rayD: RayCast2D = $RayDireita
@onready var rayE: RayCast2D = $RayEsquerda

const SPEED: float = 200
const JUMP_VELOCITY: float = -350.0
const ACC_ON_WALL: float = 200
const WALL_JUMP_VELOCITY: Vector2 = Vector2(SPEED, JUMP_VELOCITY)

var timer: Timer
var is_jumping: bool
var is_wall_jumping: bool
var is_sliding: bool



func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(timeout)

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		if (rayD.is_colliding() or rayE.is_colliding()) and velocity.y >= 0:
			velocity.y += ACC_ON_WALL * delta
			is_sliding = true
			is_jumping = false
				
		else: 
			velocity += get_gravity() * delta
			is_sliding = false
			is_jumping = true
			
		if rayD.is_colliding():
			if check_jump_wall(-1):
				sprite.flip_h = true
			
		elif rayE.is_colliding():
			if check_jump_wall(1):
				sprite.flip_h = false
	else:
		is_sliding = false
		is_jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("esquerda", "direita")
	if not is_wall_jumping:
		if direction:
			if direction < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			velocity.x = direction * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	if is_sliding:
		sprite.play("sliding")
	elif is_jumping:
		sprite.play("pular")
	elif velocity.x != 0:
		sprite.play("correr")
	else:
		sprite.play("idle")

	move_and_slide()
	
	
func check_jump_wall(direction: int) -> bool:
	if Input.is_action_just_pressed("pular"):
		velocity.y = WALL_JUMP_VELOCITY.y
		velocity.x = WALL_JUMP_VELOCITY.x * direction
		is_wall_jumping = true
		timer.start(0.2)
		return true
	
	return false

func timeout():
	is_wall_jumping = false

func die():
	died.emit()
