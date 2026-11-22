extends CanvasLayer

@onready var resumo: Label = $Painel/Resumo
@onready var som: AudioStreamPlayer = $SomDerrota


func _ready() -> void:
	hide()


func mostrar() -> void:
	resumo.text = "Voce aguentou %s e perdeu as %d vidas." % [
		GameState.formatar_tempo(GameState.tempo),
		GameState.MAX_VIDAS,
	]

	show()
	get_tree().paused = true
	som.play()


func _on_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Paneis/menu.tscn")
