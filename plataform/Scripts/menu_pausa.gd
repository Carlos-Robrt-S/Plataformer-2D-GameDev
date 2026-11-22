extends CanvasLayer

@onready var som_clique: AudioStreamPlayer = $SomClique

var bloqueado: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if bloqueado:
		return

	if event.is_action_pressed("pausar"):
		if visible:
			continuar()
		else:
			pausar()

		get_viewport().set_input_as_handled()

func pausar() -> void:
	show()
	get_tree().paused = true


func continuar() -> void:
	hide()
	get_tree().paused = false


func _on_continuar_pressed() -> void:
	som_clique.play()
	continuar()


func _on_reiniciar_pressed() -> void:
	som_clique.play()
	get_tree().paused = false            # despausar antes de trocar de cena
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	som_clique.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Paneis/menu.tscn")
