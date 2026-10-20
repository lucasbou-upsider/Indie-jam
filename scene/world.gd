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


var speed

@onready var progress_bar: ProgressBar = $Interface/ProgressBar
@onready var camera_2d: Camera2D = $Camera2D
@onready var coordoné: Label = $Interface/Coordoné


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	#pv
	progress_bar.value = GLOBAL.base_pv
	
	#deplacement de la camera
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

func _on_button_foreuse_pressed() -> void:
	add_child(FOREUSE.instantiate())
func _on_button_macon_pressed() -> void:
	add_child(MACON.instantiate())
func _on_button_four_pressed() -> void:
	add_child(FOURNEAU.instantiate())
func _on_button_bloc_cuivre_pressed() -> void:
	add_child(BLOC_CUIVRE.instantiate())
func _on_button_piti_bloc_cuivre_2_pressed() -> void:
	add_child(PETIT_BLOC_BRIQUE.instantiate())
func _on_button_scierie_pressed() -> void:
	add_child(SCIERIE.instantiate())
func _on_button_foreuse_fer_pressed() -> void:
	add_child(FOREUSE_FER.instantiate())
func _on_button_bloc_renforce_pressed() -> void:
	add_child(BLOC_RENFORCE.instantiate())
func _on_button_piti_bloc_renforce_pressed() -> void:
	add_child(PTIT_BLOC_RENFORCE.instantiate())
func _on_button_foreuse_cuivre_pressed() -> void:
	add_child(FOREUSE_CUIVRE.instantiate())
func _on_button_presse_pressed() -> void:
	add_child(PRESSE_FER.instantiate())
