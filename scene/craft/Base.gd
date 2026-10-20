extends RigidBody2D
class_name Base

var pv: int = GLOBAL.base_pv
var is_blueprint := true
var bodycount := 0
var mouse_overed := false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

#defreez pour les signaux

func defreeze():
	sleeping = false

func _ready() -> void:
	SIGNAL.connect("defreeze", defreeze)
	collision_shape_2d.disabled = true


func _process(_delta: float) -> void:
	#pv connecter pour foreuse
	GLOBAL.base_pv = pv
	
	# Input
	if Input.is_action_just_pressed("click gauche"):
		place_self()

	# blueprint
	if is_blueprint == true:
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)
	
	# regarder si posibilité sde placer pour la couleur
	if is_blueprint:
		if bodycount == 0:
			sprite_2d.self_modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.self_modulate = Color(0.729, 0.114, 0.267, 0.565)
	else:
		sprite_2d.self_modulate = Color(1.0, 0.98, 0.984, 0.98)

func place_self():
	if bodycount == 0:
		is_blueprint = false
		collision_shape_2d.disabled = false

func _on_area_2d_area_exited(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint:
		bodycount -= 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	#degats
	if !is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= 1
	#regarder si possible de placer
	if is_blueprint and area.name != "verif_Area2D":
		bodycount += 1

func _on_area_2d_mouse_entered() -> void:
	mouse_overed = true
func _on_area_2d_mouse_exited() -> void:
	mouse_overed = false
