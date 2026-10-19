extends Node2D

const BASE = preload("uid://byxo1qtpjx30p")
const FOREUSE = preload("uid://02wx8g0s1olf")

var speed = 30

@onready var progress_bar: ProgressBar = $Interface/ProgressBar
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	#pv
	progress_bar.value = GLOBAL.base_pv
	
	#deplacement de la camera
	if Input.is_action_pressed("courir"):
		speed = 40
	else:
		speed = 30
	if Input.is_action_pressed("droite"):
		camera_2d.position += Vector2(speed,0)
	if Input.is_action_pressed("gauche"):
		camera_2d.position += Vector2(-speed,0)
	if Input.is_action_pressed("haut"):
		camera_2d.position += Vector2(0,-speed)
	if Input.is_action_pressed("bas"):
		camera_2d.position += Vector2(0,speed)



func _on_button_base_pressed() -> void:
	add_child(BASE.instantiate())
func _on_button_foreuse_pressed() -> void:
	add_child(FOREUSE.instantiate())
