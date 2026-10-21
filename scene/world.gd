extends Node2D

const FOREUSE = preload("uid://02wx8g0s1olf")
const MACON = preload("uid://bmqj2ocb6rh52")
const FOURNEAU = preload("uid://oowuyr1jo2gt")
const BLOC_CUIVRE = preload("uid://cw4heslictg5a")
const PETIT_BLOC_BRIQUE = preload("uid://bebxrd2yuskte")
const SCIERIE = preload("uid://cwmo1yckrvxbn")
const FOREUSE_FER = preload("uid://k50d24v80i8n")
const BLOC_RENFORCE = preload("uid://djp8kufdndlut")
const PTIT_BLOC_RENFORCE = preload("uid://b86jdqoskpqse")
const FOREUSE_CUIVRE = preload("uid://cpcrfnudbmj5r")
const PRESSE_FER = preload("uid://bpalbk5akejka")
const BLOC_BRONZE = preload("uid://b7a2fcystwnuy")
const PETIT_BLOC_BRONZE = preload("uid://bcbxkhon40xyh")
const FOREUSE_ETAIN = preload("uid://ci1fnijdajo78")
const BLOC_ACIER = preload("uid://dyu8uxfjunefj")
const PETIT_BLOC_ACIER = preload("uid://dt2mu2qspab7p")
const BLOC_GLUANTITE = preload("uid://bc266li4ka4m4")
const PETIT_BLOC_GLUANTITE = preload("uid://b05mxi2sgjtaq")
const BLOC_TOPAXIUM = preload("uid://b050uia4uvrc")
const PETIT_BLOC_TOPAXIUM = preload("uid://r24foany4415")
const BLOC_VOIDIUM = preload("uid://dcwmhedpnjfb7")
const PETIT_BLOC_VOIDIUM = preload("uid://crq1oh7y42s1t")
const FUSIONNEUR_DE_BRONZE = preload("uid://78oce3mk04lx")
const TRANSFORMATEUR = preload("uid://rtn0xcaetf3g")
const CRAMEUR = preload("uid://c3d6mctffdjwo")
const BASE = preload("uid://byxo1qtpjx30p")
const FUSIONNEUR_D_ACIER = preload("uid://b08u6oy6tq0n8")

var speed
var quake_queue = []
var tween: Tween

@onready var progress_bar: ProgressBar = $Interface/ProgressBar
@onready var camera_2d: Camera2D = $Camera2D
@onready var coordoné: Label = $Interface/Coordoné
@onready var quake_timer: Timer = $kayou_spawn/quake_timer
@onready var quaker: Timer = $kayou_spawn/quaker

@onready var tool_tip: RichTextLabel = $Interface/ToolTip/RichTextLabel








func _ready() -> void:
	tool_tip.get_parent().visible = false
	tool_tip.get_parent().offset_transform_position = Vector2(0, -100)
	add_child(BASE.instantiate())


func _process(_delta: float) -> void:
	#pv
	progress_bar.value = GLOBAL.base_pv
	
	#update tooltip
	if GLOBAL.selected != null:
		tool_tip.text = GLOBAL.selected.tooltipify()
	
	#deplacement de la camera
	if Input.is_action_just_pressed("verif_pv"):
		print(calculate_production("pierre"))
	if Input.is_action_pressed("courir"):
		speed = 5
	else:
		speed = 10
	if Input.is_action_pressed("droite"):
		camera_2d.position += Vector2(speed,0)
	if Input.is_action_pressed("gauche"):
		camera_2d.position += Vector2(-speed,0)
	if Input.is_action_pressed("haut"):
		camera_2d.position += Vector2(0,-speed)
	if Input.is_action_pressed("bas"):
		camera_2d.position += Vector2(0,speed)

#coordonées 
	coordoné.text = str(Vector2i(get_global_mouse_position()))
	if Vector2i(get_global_mouse_position()).x  > -400 and Vector2i(get_global_mouse_position()).x  < 400:
		coordoné.self_modulate = Color(1.0, 1.0, 1.0)
	elif Vector2i(get_global_mouse_position()).x  > -900 and Vector2i(get_global_mouse_position()).x  < 900:
		coordoné.self_modulate = Color(1.0, 0.559, 0.274)
	else:
		coordoné.self_modulate = Color(1.0, 0.245, 0.188)

func try_spawn(batiment):
	if GLOBAL.selected == null:
		var newbat = batiment.instantiate()
		newbat.global_position = get_global_mouse_position()
		add_child(newbat)

func calculate_production(ressource):
	var res: float = 0.0
	for bat in self.get_children():
		if bat is foreuse:
			if bat.is_blueprint:
				continue
			if bat.minerai_produit == ressource:
				res += bat.production/bat.production_timer.wait_time
			elif bat.minerai_produit2 == ressource:
				res += bat.production2/bat.production_timer.wait_time
		elif bat is transformateur:
			if bat.is_blueprint:
				continue
			if bat.demande == ressource:
				res -= bat.cout_demande/bat.production_timer.wait_time
			elif bat.demande2 == ressource:
				res -= bat.cout_demande2/bat.production_timer.wait_time
			elif bat.minerai_produit == ressource:
				res += bat.production/bat.production_timer.wait_time
	return str(res)+"/s"

func unselect() -> void:
	if GLOBAL.selected != null:
		tool_tip.get_parent().offset_transform_position = Vector2(0, -100)
		tool_tip.get_parent().visible = false
		tool_tip.text = "no building selected"
		GLOBAL.selected.modulate = Color(1, 1, 1, 1)
		GLOBAL.selected = null

func select(node) -> void:
	GLOBAL.selected = node
	tool_tip.get_parent().visible = true
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(tool_tip.get_parent(), "offset_transform_position", Vector2(0,10), 0.05)
	tween.tween_property(tool_tip.get_parent(), "offset_transform_position", Vector2(0,0), 0.1)
	tool_tip.text = GLOBAL.selected.tooltipify()
	GLOBAL.selected.modulate =Color(0.8, 1, 0.8, 1.0)


func quake(intensity):
	for c in get_children():
		if c is bloc or c is transformateur or c is foreuse:
			c.linear_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1))*intensity

func earth_quake(intensity):
	for i in range(3):
		quake_queue.push_back(intensity)

func _on_quake_timer_timeout() -> void:
	if quake_queue.size() > 0:
		quake(quake_queue.pop_front())

func _on_quaker_timeout() -> void:
	if randi_range(0, 4) == 0:
		earth_quake(randi_range(200, 700))





func _on_button_foreuse_pressed() -> void:
	try_spawn(FOREUSE)
func _on_button_macon_pressed() -> void:
	try_spawn(MACON)
func _on_button_four_pressed() -> void:
	try_spawn(FOURNEAU)
func _on_button_bloc_cuivre_pressed() -> void:
	try_spawn(BLOC_CUIVRE)
func _on_button_piti_bloc_cuivre_2_pressed() -> void:
	try_spawn(PETIT_BLOC_BRIQUE)
func _on_button_scierie_pressed() -> void:
	try_spawn(SCIERIE)
func _on_button_foreuse_fer_pressed() -> void:
	try_spawn(FOREUSE_FER)
func _on_button_bloc_renforce_pressed() -> void:
	try_spawn(BLOC_RENFORCE)
func _on_button_piti_bloc_renforce_pressed() -> void:
	try_spawn(PTIT_BLOC_RENFORCE)
func _on_button_foreuse_cuivre_pressed() -> void:
	try_spawn(FOREUSE_CUIVRE)
func _on_button_presse_pressed() -> void:
	try_spawn(PRESSE_FER)
func _on_button_bloc_bronze_pressed() -> void:
	try_spawn(BLOC_BRONZE)
func _on_button_piti_bloc_bronze_pressed() -> void:
	try_spawn(PETIT_BLOC_BRONZE)
func _on_button_foreuse_etain_pressed() -> void:
	try_spawn(FOREUSE_ETAIN)
func _on_button_piti_bloc_acier_pressed() -> void:
	try_spawn(PETIT_BLOC_ACIER)
func _on_button_bloc_acier_pressed() -> void:
	try_spawn(BLOC_ACIER)
func _on_button_bloc_gluantite_pressed() -> void:
	try_spawn(BLOC_GLUANTITE)
func _on_button_piti_bloc_gluantite_pressed() -> void:
	try_spawn(PETIT_BLOC_GLUANTITE)
func _on_button_piti_bloc_topaxium_pressed() -> void:
	try_spawn(PETIT_BLOC_TOPAXIUM)
func _on_button_bloc_topaxium_pressed() -> void:
	try_spawn(BLOC_TOPAXIUM)
func _on_button_piti_bloc_voidium_pressed() -> void:
	try_spawn(PETIT_BLOC_VOIDIUM)
func _on_button_bloc_voidium_pressed() -> void:
	try_spawn(BLOC_VOIDIUM)
func _on_button_fusionneur_bronze_pressed() -> void:
	try_spawn(FUSIONNEUR_DE_BRONZE)
func _on_button_transformateur_pressed() -> void:
	try_spawn(TRANSFORMATEUR)
func _on_button_crameur_pressed() -> void:
	try_spawn(CRAMEUR)
func _on_button_fusionneur_dacier_pressed() -> void:
	try_spawn(FUSIONNEUR_D_ACIER)
