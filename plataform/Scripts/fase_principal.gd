extends Node2D
# Script da raiz de cada fase.

signal level_completed

@onready var spawn = $Spawn
@onready var player = $Player
@onready var goal = $Meta
# Retângulo (em pixels) que limita a câmera nesta fase.
@export var camera_limits: Rect2i = Rect2i(0, 0, 1920, 640)

var camera: Camera2D = null


func _ready() -> void:
	camera = player.find_child("Camera2D", true, false)
	if camera != null:
		camera.limit_left = camera_limits.position.x
		camera.limit_top = camera_limits.position.y
		camera.limit_right = camera_limits.end.x
		camera.limit_bottom = camera_limits.end.y

	player.died.connect(respawn)
	goal.body_entered.connect(_on_goal_body_entered)
	respawn()
	
func respawn() -> void:
	player.global_position = spawn.global_position
	player.velocity = Vector2.ZERO
	if camera != null:
		camera.reset_smoothing()

func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("fase cmpleta")
		level_completed.emit()
