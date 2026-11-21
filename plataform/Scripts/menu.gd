extends Control

var botoes: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	botoes = $Botoes
	botoes.visible = true
	$GameName.visible = true
	$CredMenu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/fase_principal.tscn")



func _on_creditos_pressed() -> void:
	$GameName.visible = false
	botoes.visible = false
	$CredMenu.visible = true


func _on_return_pressed() -> void:
	$GameName.visible = true
	botoes.visible = true
	$CredMenu.visible = false


func _on_sair_pressed() -> void:
	get_tree().quit()
