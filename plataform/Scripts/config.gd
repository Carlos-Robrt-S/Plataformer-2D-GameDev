extends Control

@onready var geral: HSlider = $Painel/Geral/Slider
@onready var musica: HSlider = $Painel/Musica/Slider
@onready var sfx: HSlider = $Painel/Sfx/Slider
@onready var tela_cheia: CheckButton = $Painel/TelaCheia
@onready var recorde_label: Label = $Painel/Recorde
@onready var som_teste: AudioStreamPlayer = $SomTeste


func _ready() -> void:
	# Os sliders comecam mostrando o que esta salvo.
	geral.value = GameState.volume_geral
	musica.value = GameState.volume_musica
	sfx.value = GameState.volume_sfx
	tela_cheia.button_pressed = \
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	# Conectar DEPOIS de definir os valores, senao o proprio
	# preenchimento dispara os sinais.
	geral.value_changed.connect(_ao_mudar_geral)
	musica.value_changed.connect(_ao_mudar_musica)
	sfx.value_changed.connect(_ao_mudar_sfx)

	_atualizar_recorde()


func _ao_mudar_geral(valor: float) -> void:
	GameState.volume_geral = valor
	GameState.aplicar_volumes()


func _ao_mudar_musica(valor: float) -> void:
	GameState.volume_musica = valor
	GameState.aplicar_volumes()


func _ao_mudar_sfx(valor: float) -> void:
	GameState.volume_sfx = valor
	GameState.aplicar_volumes()
	som_teste.play()        # deixa o jogador ouvir o novo volume


func _on_tela_cheia_toggled(ligado: bool) -> void:
	if ligado:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_apagar_recorde_pressed() -> void:
	GameState.melhor_tempo = 0.0
	GameState.salvar()
	_atualizar_recorde()


func _atualizar_recorde() -> void:
	if GameState.melhor_tempo <= 0.0:
		recorde_label.text = "Recorde: nenhum ainda"
	else:
		recorde_label.text = "Recorde: %s  (rank %s)" % [
			GameState.formatar(GameState.melhor_tempo),
			GameState.rank_de(GameState.melhor_tempo),
		]


func _on_voltar_pressed() -> void:
	GameState.salvar()
	get_tree().change_scene_to_file("res://Scenes/Paneis/menu.tscn")
