extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rayD: RayCast2D = $RayDireita
@onready var rayE: RayCast2D = $RayEsquerda

const SPEED: float = 200
const JUMP_VELOCITY: float = -350.0
const ACC_ON_WALL: float = 200
const WALL_JUMP_VELOCITY: Vector2 = Vector2(SPEED, JUMP_VELOCITY)

var timer: Timer
var is_pulando: bool
var is_caindo: bool
var is_wall_jumping: bool



func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(timeout)

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		if (rayD.is_colliding() or rayE.is_colliding()) and velocity.y >= 0:
			velocity.y += ACC_ON_WALL * delta
				
		else: 
			velocity += get_gravity() * delta
			
		if rayD.is_colliding():
			check_jump_wall(-1)
			
		elif rayE.is_colliding():
			check_jump_wall(1)

	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
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
		
	if is_pulando or is_caindo:
		sprite.play("pular")
	elif velocity.x != 0:
		sprite.play("correr")
	else:
		sprite.play("idle")

	move_and_slide()
	
	
func check_jump_wall(direction: int) -> void:
	if Input.is_action_just_pressed("pular"):
		velocity.y = WALL_JUMP_VELOCITY.y
		velocity.x = WALL_JUMP_VELOCITY.x * direction
		is_wall_jumping = true
		timer.start(0.2)


func timeout():
	is_wall_jumping = false
