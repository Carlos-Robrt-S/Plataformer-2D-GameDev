extends Node2D

signal level_completed

const FINAL_CHECKPOINT: int = 5

@onready var spawn = $Spawn
@onready var player = $Player

@onready var som_morte: AudioStreamPlayer = $SomMorte


@export var camera_limits: Rect2i = Rect2i(0, 0, 2528, 640)

var camera: Camera2D = null
var respawn_position: Vector2
var checkpoint_order: int = 0
var level_finished: bool = false


func _ready() -> void:
	#$Player/Camera2D/MenuPause.visible = false
	camera = player.find_child("Camera2D", true, false)
	if camera != null:
		camera.limit_left = camera_limits.position.x
		camera.limit_top = camera_limits.position.y
		camera.limit_right = camera_limits.end.x
		camera.limit_bottom = camera_limits.end.y
	
	respawn_position = spawn.global_position
	
	for checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		checkpoint.connect("activated", _on_checkpoint_activated)
	
	player.died.connect(_ao_morrer)
	level_completed.connect(_ao_completar)
	
	GameState.iniciar_fase()
	respawn()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pausar"):
		$Player/Camera2D/MenuPause.visible = true
		get_tree().paused = true

func _on_checkpoint_activated(pos: Vector2, order: int) -> void:
	if order <= checkpoint_order or level_finished:
		return
	
	checkpoint_order = order
	respawn_position = pos
	
	if order == FINAL_CHECKPOINT:
		level_finished = true
		level_completed.emit()


func respawn() -> void:
	player.global_position = respawn_position
	player.velocity = Vector2.ZERO
	
	if camera != null:
		camera.reset_smoothing()


func _on_button_pressed() -> void:
	$Player/Camera2D/MenuPause.visible = false
	get_tree().paused = false


func _on_sair_pressed() -> void:
	get_tree().quit()

func _ao_morrer() -> void:
	if level_finished:
		return
		
	som_morte.play()
	
	if GameState.registrar_morte():
		respawn()
	else:
		level_finished = true
		$GameOver.mostrar()
		
func _ao_completar() -> void:
	var resultado: Dictionary = GameState.concluir_fase()
	$Vitoria.mostrar(resultado)
