extends Node2D
# Script da raiz de cada fase.

signal level_completed

@onready var spawn = $Spawn
@onready var player = $Jogador
@onready var goal = $Meta

func _ready() -> void:
	#player.died.connect(respawn)
	goal.body_entered.connect(_on_goal_body_entered)
	respawn()

func respawn() -> void:
	player.global_position = spawn.global_position
	player.velocity = Vector2.ZERO

func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("fase cmpleta")
		level_completed.emit()
