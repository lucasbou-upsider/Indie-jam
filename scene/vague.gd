extends Node2D
@warning_ignore_start("integer_division")


@onready var vague_timer: Timer = $vague_Timer
@onready var label_time_left: RichTextLabel = $"../Interface/Panel_vague/time_left"
@onready var warner: AudioStreamPlayer = $warner
@warning_ignore("shadowed_global_identifier") @onready var kayou_spawn: Node2D = $"../kayou_spawn"
@export var vague_number = 0

#tout les batiments oui je vais faire tout sa on a pas le temsp aazhdgquisgdyqgsduig
@onready var button_bloc_renforce: Button = $"../Interface/Panel_mur/GridBloc/Button_bloc_renforce"
@onready var button_piti_bloc_renforce: Button = $"../Interface/Panel_mur/GridBloc/Button_piti_bloc_renforce"
@onready var button_bloc_bronze: Button = $"../Interface/Panel_mur/GridBloc/Button_bloc_bronze"
@onready var button_piti_bloc_bronze: Button = $"../Interface/Panel_mur/GridBloc/Button_piti_bloc_bronze"
@onready var button_bloc_acier: Button = $"../Interface/Panel_mur/GridBloc/Button_bloc_acier"
@onready var button_piti_bloc_acier: Button = $"../Interface/Panel_mur/GridBloc/Button_piti_bloc_acier"
@onready var button_bloc_gluantite: Button = $"../Interface/Panel_mur/GridBloc/Button_bloc_gluantite"
@onready var button_piti_bloc_gluantite: Button = $"../Interface/Panel_mur/GridBloc/Button_piti_bloc_gluantite"
@onready var button_bloc_topaxium: Button = $"../Interface/Panel_mur/GridBloc/Button_bloc_topaxium"
@onready var button_piti_bloc_topaxium: Button = $"../Interface/Panel_mur/GridBloc/Button_piti_bloc_topaxium"
@onready var button_bloc_voidium: Button = $"../Interface/Panel_mur/GridBloc/Button_bloc_voidium"
@onready var button_piti_bloc_voidium: Button = $"../Interface/Panel_mur/GridBloc/Button_piti_bloc_voidium"
@onready var h_separator_2: HSeparator = $"../Interface/Panel_construction/VBoxContainer/HSeparator2"
@onready var button_foreuse_cuivre: Button = $"../Interface/Panel_construction/VBoxContainer/Button_foreuse_cuivre"
@onready var button_foreuse_etain: Button = $"../Interface/Panel_construction/VBoxContainer/Button_foreuse_etain"
@onready var button_fusionneur_bronze: Button = $"../Interface/Panel_construction/VBoxContainer/Button_fusionneur_bronze"
@onready var button_transformateur: Button = $"../Interface/Panel_construction/VBoxContainer/Button_transformateur"
@onready var h_separator_4: HSeparator = $"../Interface/Panel_construction/VBoxContainer/HSeparator4"
@onready var button_crameur: Button = $"../Interface/Panel_construction/VBoxContainer/Button_crameur"
@onready var button_fusionneur_d_acier: Button = $"../Interface/Panel_construction/VBoxContainer/Button_fusionneur_d'acier"
@onready var button_transformateur_puissant: Button = $"../Interface/Panel_construction/VBoxContainer/Button_transformateur_puissant"
@onready var button_foreuse_voidium: Button = $"../Interface/Panel_construction/VBoxContainer/Button_foreuse_voidium"
@onready var button_foreuse_topaxium: Button = $"../Interface/Panel_construction/VBoxContainer/Button_foreuse_topaxium"
@onready var button_foreuse_gluantite: Button = $"../Interface/Panel_construction/VBoxContainer/Button_foreuse_gluantite"
@onready var button_four_voidium: Button = $"../Interface/Panel_construction/VBoxContainer/Button_four_voidium"
@onready var button_four_gluantite: Button = $"../Interface/Panel_construction/VBoxContainer/Button_four_gluantite"
@onready var button_four_topaxium: Button = $"../Interface/Panel_construction/VBoxContainer/Button_four_topaxium"







const nbr_meteorite = [100, 150, 200, 200, 250]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if vague_timer.time_left <= 50:
		label_time_left.text = "[shake rate=15 level=7]" + str(int(vague_timer.time_left))
		label_time_left.self_modulate = Color(0.869, 0.0, 0.09)
	elif vague_timer.time_left <= 100:
		label_time_left.text = "[shake rate=10 level=4]" + str(int(vague_timer.time_left))
		label_time_left.self_modulate = Color(1.0, 0.476, 0.428)
	elif vague_timer.time_left > 100:
		label_time_left.text = str(int(vague_timer.time_left))
		label_time_left.self_modulate = Color(1.0, 1.0, 1.0)

	if vague_timer.time_left < 100 and vague_timer.time_left+delta >=100:
		warner.play()
	elif vague_timer.time_left < 50 and vague_timer.time_left+delta >=50:
		$"../musique/base".stream_paused = true
		$"../musique/meteor".play()

func _on_vague_timer_timeout() -> void:
	get_parent().camera.screen_shake(0, 7, -2)
	kayou_spawn.wave(nbr_meteorite[vague_number%nbr_meteorite.size()], int(vague_number/nbr_meteorite.size()))
	vague_number += 1

	await get_tree().create_timer(10).timeout
	if int(vague_number/nbr_meteorite.size()) == 1:
		h_separator_2.visible = true
		button_foreuse_etain.visible = true
		button_foreuse_cuivre.visible = true
		button_transformateur.visible = true
		button_fusionneur_bronze.visible = true
		button_bloc_bronze.visible = true
		button_piti_bloc_bronze.visible = true
	elif int(vague_number/nbr_meteorite.size()) == 2:
		h_separator_4.visible = true
		button_crameur.visible = true
		button_fusionneur_d_acier.visible = true
		button_transformateur_puissant.visible = true
		button_bloc_acier.visible = true
		button_piti_bloc_acier.visible = true
	elif int(vague_number/nbr_meteorite.size()) == 3:
		button_foreuse_voidium.visible = true
		button_foreuse_topaxium.visible = true
		button_foreuse_gluantite.visible = true
		button_four_gluantite.visible = true
		button_four_topaxium.visible = true
		button_four_voidium.visible = true
		button_bloc_gluantite.visible = true
		button_piti_bloc_gluantite.visible = true
		button_bloc_topaxium.visible = true
		button_piti_bloc_topaxium.visible = true
		button_bloc_voidium.visible = true
		button_piti_bloc_voidium.visible = true
	$"../musique/meteor".stop()
	$"../musique/base".stream_paused = false
	vague_timer.start()


func save():
	var save_dict = {
		"filename": "vague",
		"time_left": vague_timer.time_left,
		"vague_number": vague_number
	}
	return save_dict
