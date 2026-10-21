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


var speed
var quake_queue = []

@onready var progress_bar: ProgressBar = $Interface/ProgressBar
@onready var camera_2d: Camera2D = $Camera2D
@onready var coordoné: Label = $Interface/Coordoné
@onready var quake_timer: Timer = $kayou_spawn/quake_timer
@onready var quaker: Timer = $kayou_spawn/quaker


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	#pv
	progress_bar.value = GLOBAL.base_pv
	
	#deplacement de la camera
	if Input.is_action_just_pressed("verif_pv"):
		earth_quake(500)
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
	if not GLOBAL.mouse_busy:
		spawn(BLOC_TOPAXIUM)
func _on_button_piti_bloc_voidium_pressed() -> void:
	if not GLOBAL.mouse_busy:
		spawn(PETIT_BLOC_VOIDIUM)
func _on_button_bloc_voidium_pressed() -> void:
	if not GLOBAL.mouse_busy:
		spawn(BLOC_VOIDIUM)
func _on_button_fusionneur_bronze_pressed() -> void:
	if not GLOBAL.mouse_busy:
		spawn(FUSIONNEUR_DE_BRONZE)
