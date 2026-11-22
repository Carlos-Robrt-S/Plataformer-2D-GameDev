extends CanvasLayer

@onready var tempo_label: Label = $Tempo
@onready var vidas_label: Label = $Vidas


func _ready() -> void:
	GameState.tempo_alterado.connect(_atualizar_tempo)
	GameState.vidas_alteradas.connect(_atualizar_vidas)

	_atualizar_tempo(GameState.tempo)
	_atualizar_vidas(GameState.vidas)


func _atualizar_tempo(t: float) -> void:
	tempo_label.text = GameState.formatar_tempo(t)


func _atualizar_vidas(v: int) -> void:
	vidas_label.text = "♥ ".repeat(maxi(v, 0))
