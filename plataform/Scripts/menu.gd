extends Control

@onready var botoes: Control = $Botoes
@onready var recorde: Label = $Recorde
@onready var som_clique: AudioStreamPlayer = $SomClique


func _ready() -> void:
	botoes.visible = true
	$GameName.visible = true
	$CredMenu.visible = false
	_mostrar_recorde()


func _mostrar_recorde() -> void:
	if GameState.melhor_tempo <= 0.0:
		recorde.text = "Nenhum recorde ainda"
	else:
		recorde.text = "Melhor tempo: %s   (rank %s)" % [
			GameState.formatar_tempo(GameState.melhor_tempo),
			GameState.rank_de(GameState.melhor_tempo),
		]


func _on_iniciar_pressed() -> void:
	som_clique.play()
	await get_tree().create_timer(0.1).timeout      # deixa o clique ser ouvido
	get_tree().change_scene_to_file("res://Scenes/levels/fase_principal.tscn")


func _on_config_pressed() -> void:
	som_clique.play()
	get_tree().change_scene_to_file("res://Scenes/Paneis/config.tscn")


func _on_creditos_pressed() -> void:
	som_clique.play()
	$GameName.visible = false
	botoes.visible = false
	$CredMenu.visible = true


func _on_return_pressed() -> void:
	som_clique.play()
	$GameName.visible = true
	botoes.visible = true
	$CredMenu.visible = false


func _on_sair_pressed() -> void:
	get_tree().quit()
