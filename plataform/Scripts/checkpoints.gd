extends Area2D

signal activated(respawn_position: Vector2, order: int)

@export_range(1, 7) var order: int = 1

@onready var marker: CanvasItem = $Sprite2D
@onready var respawn_point: Marker2D = $respawn_point

var is_active := false


func _ready() -> void:
	marker.modulate = Color(0.5, 0.5, 0.5)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if is_active or not body.is_in_group("player"):
		return

	is_active = true
	marker.modulate = Color(0.5, 1.0, 0.5)
	activated.emit(respawn_point.global_position, order)
