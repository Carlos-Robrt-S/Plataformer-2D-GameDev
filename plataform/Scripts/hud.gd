extends CanvasLayer

const CORACAO_CHEIO: Texture2D = preload("res://Assets/ui/heart_full.png")
const CORACAO_VAZIO: Texture2D = preload("res://Assets/ui/heart_empty.png")

@onready var tempo_label: Label = $PainelTempo/Tempo
@onready var vidas_box: HBoxContainer = $PainelVidas/Vidas

var coracoes: Array[TextureRect] = []


func _ready() -> void:
	for i in GameState.MAX_VIDAS:
		var icone := TextureRect.new()
		icone.custom_minimum_size = Vector2(39, 36)
		icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icone.texture = CORACAO_CHEIO
		vidas_box.add_child(icone)
		coracoes.append(icone)

	GameState.tempo_alterado.connect(_atualizar_tempo)
	GameState.vidas_alteradas.connect(_atualizar_vidas)

	_atualizar_tempo(GameState.tempo)
	_atualizar_vidas(GameState.vidas)


func _atualizar_tempo(t: float) -> void:
	tempo_label.text = GameState.formatar_tempo(t)


func _atualizar_vidas(v: int) -> void:
	for i in coracoes.size():
		coracoes[i].texture = CORACAO_CHEIO if i < v else CORACAO_VAZIO
