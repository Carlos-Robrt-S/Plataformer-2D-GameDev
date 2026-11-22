extends CanvasLayer

@onready var rank_label: Label = $Painel/Rank
@onready var novo_recorde: Label = $Painel/NovoRecorde
@onready var tempo_label: Label = $Painel/Tempo
@onready var mortes_label: Label = $Painel/Mortes
@onready var final_label: Label = $Painel/TempoFinal
@onready var recorde_label: Label = $Painel/Recorde
@onready var som: AudioStreamPlayer = $SomVitoria


func _ready() -> void:
	hide()


func mostrar(r: Dictionary) -> void:
	var penalidade: float = r["mortes"] * GameState.PENALIDADE_MORTE

	tempo_label.text = "Tempo na fase: %s" % GameState.formatar_tempo(r["tempo"])
	mortes_label.text = "Mortes: %d   (penalidade +%.0fs)" % [r["mortes"], penalidade]
	final_label.text = "TEMPO FINAL: %s" % GameState.formatar_tempo(r["final"])
	recorde_label.text = "Seu recorde: %s" % GameState.formatar_tempo(GameState.melhor_tempo)
	novo_recorde.visible = r["recorde"]

	rank_label.text = "?"
	show()
	get_tree().paused = true
	som.play()

	# Suspense: a nota aparece meio segundo depois, com um estouro.
	await get_tree().create_timer(0.5).timeout
	rank_label.text = r["rank"]
	rank_label.pivot_offset = rank_label.size / 2.0    # centro do Label
	rank_label.scale = Vector2(2.5, 2.5)

	var pop := create_tween()
	pop.tween_property(rank_label, "scale", Vector2.ONE, 0.4) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Paneis/menu.tscn")	
