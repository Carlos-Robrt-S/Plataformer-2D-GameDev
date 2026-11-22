extends Node

const CAMINHO_SAVE: String = "user://plataformer.cfg"
const MAX_VIDAS: int = 5
const PENALIDADE_MORTE: float = 2.0

const RANKS: Array = [["S", 60.0], ["A", 80.0], ["B", 105.0], ["C", 140.0]]

signal vidas_alteradas(vidas:int)
signal tempo_alterado(tempo: float)

var vidas: int = MAX_VIDAS
var tempo: float = 0.0
var mortes: int = 0
var cronometro_ativo:bool = false

var melhor_tempo: float = 0.0
var volume_geral: float = 1.0
var volume_musica: float = 0.8
var volume_sfx: float = 0.8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#carregar()
	#aplicar_volumes()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cronometro_ativo:
		tempo += delta
		tempo_alterado.emit(tempo)

func iniciar_fase() -> void:
	vidas = MAX_VIDAS
	tempo = 0.0
	mortes = 0
	cronometro_ativo = true
	vidas_alteradas.emit(vidas)
	tempo_alterado.emit(tempo)
	
func registrar_morte() -> bool:
	mortes += 1
	vidas -= 1
	vidas_alteradas.emit(vidas)
	
	if vidas <=0:
		cronometro_ativo = false
		return false
		
	return true
	
func tempo_final() -> float:
	return tempo + mortes * PENALIDADE_MORTE
	
func concluir_fase() -> Dictionary:
	cronometro_ativo = false
	var final: float = tempo_final()
	var recorde: bool = melhor_tempo <= 0.0 or final < melhor_tempo
	
	if recorde:
		melhor_tempo = final
		salvar()
	
	return {
		"tempo": tempo,
		"mortes": mortes,
		"final": final,
		"rank": rank_de(final),
		"recorde": recorde,
	}

func rank_de(t: float) -> String:
	for faixa in RANKS:
		if t <= faixa[1]:
			return faixa[0]
	return "D"
	
func formatar_tempo(t: float) -> String:
	var minutos: int = floori(t/60.0)
	var segundos: int = floori(fmod(t, 60.0))
	var centesimos: int = floori(fmod(t, 1.0) * 100.0)
	return "%02d:%02d.%02d" % [minutos, segundos, centesimos]
	
func aplicar_volumes() -> void:
	definir_volume("Master", volume_geral)
	definir_volume("Music", volume_musica)
	definir_volume("SFX", volume_sfx)
	
func definir_volume(bus: String, valor: float) -> void:
	var indice: int = AudioServer.get_bus_index(bus)
	if indice < 0:
		return
		
	AudioServer.set_bus_mute(indice, valor <= 0.0)
	if valor > 0.0:
		AudioServer.set_bus_volume_db(indice, linear_to_db(valor))

func salvar() -> void:
	var cfg:= ConfigFile.new()
	cfg.set_value("recorde", "melhor_tempo", melhor_tempo)
	cfg.set_value("audio", "geral", volume_geral)
	cfg.set_value("audio", "musica", volume_musica)
	cfg.set_value("audio", "sfx", volume_sfx)
	cfg.save(CAMINHO_SAVE)
	
func carregar() -> void:
	var cfg:= ConfigFile.new()
	if cfg.load(CAMINHO_SAVE) != OK:
		return
	melhor_tempo = cfg.get_value("recorde", "melhor_tempo", 0.0)
	volume_geral = cfg.get_value("audio", "geral", 1.0)
	volume_musica = cfg.get_value("audio", "musica", 0.8)
	volume_sfx = cfg.get_value("audio", "sfx", 0.8)
