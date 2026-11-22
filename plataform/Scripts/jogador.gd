extends CharacterBody2D

signal died

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rayD: RayCast2D = $RayDireita
@onready var rayE: RayCast2D = $RayEsquerda

@onready var som_pulo: AudioStreamPlayer = $SomPulo
@onready var som_duplo: AudioStreamPlayer = $SomPuloDuplo	

const SPEED: float = 200
const JUMP_VELOCITY: float = -350.0
const ACC_ON_WALL: float = 200
const WALL_JUMP_VELOCITY: Vector2 = Vector2(SPEED, JUMP_VELOCITY)


const MAX_PULOS: int = 2
const FORCA_PULO_DUPLO: float = 0.85   # o 2o pulo e um pouco mais curto
const COYOTE_TIME: float = 0.1
const JUMP_BUFFER_TIME: float = 0.1

var pulos_restantes: int = MAX_PULOS
var coyote_timer: float = 0.0
var buffer_timer: float = 0.0
var giro: Tween


var timer: Timer
var is_jumping: bool
var is_wall_jumping: bool
var is_sliding: bool



func _init() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(timeout)

func _physics_process(delta: float) -> void:
	
	coyote_timer = maxf(coyote_timer - delta, 0.0)
	buffer_timer = maxf(buffer_timer - delta, 0.0)

	# Toda vez que o jogador aperta, a intencao fica guardada no buffer.
	if Input.is_action_just_pressed("pular"):
		buffer_timer = JUMP_BUFFER_TIME
		
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
		
		pulos_restantes = MAX_PULOS    # no chao, os pulos recarregam
		coyote_timer = COYOTE_TIME 

	#no ar, gasta o 2o pulo
	if buffer_timer > 0.0 and pulos_restantes > 0:
		pular(coyote_timer <= 0.0)

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
	if buffer_timer <= 0.0:
		return false

	velocity.y = WALL_JUMP_VELOCITY.y
	velocity.x = WALL_JUMP_VELOCITY.x * direction
	is_wall_jumping = true

	pulos_restantes = MAX_PULOS - 1   # a parede devolve o pulo duplo
	buffer_timer = 0.0                # consome a entrada
	coyote_timer = 0.0

	timer.start(0.2)
	som_pulo.play()
	return true

func timeout():
	is_wall_jumping = false

func die():
	died.emit()

func pular(duplo: bool) -> void:
	if duplo:
		velocity.y = JUMP_VELOCITY * FORCA_PULO_DUPLO
		pulos_restantes = 0
		girar_sprite()
		som_duplo.play()
	else:
		velocity.y = JUMP_VELOCITY
		pulos_restantes = MAX_PULOS - 1
		som_pulo.play()

	is_jumping = true
	buffer_timer = 0.0      # consome a entrada, para nao pular duas vezes
	coyote_timer = 0.0      # e fecha a janela de perdao
	
func girar_sprite() -> void:
	if giro != null and giro.is_valid():
		giro.kill()

	sprite.rotation = 0.0
	var sentido: float = -1.0 if sprite.flip_h else 1.0
	giro = create_tween()
	giro.tween_property(sprite, "rotation", sentido * TAU, 0.3)
	giro.tween_callback(func() -> void: sprite.rotation = 0.0)
