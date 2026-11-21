extends Area2D
# Obstáculo genérico: mata o jogador ao encostar.
# Se "move_offset" for diferente de zero, o obstáculo vai e volta.

@export var move_offset: Vector2 = Vector2.ZERO
@export var move_time: float = 1.5

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if move_offset != Vector2.ZERO:
		var tween := create_tween().set_loops()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "position", position + move_offset, move_time)
		tween.tween_property(self, "position", position, move_time)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("die"):
		body.die()
