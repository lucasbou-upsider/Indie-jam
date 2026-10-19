extends RigidBody2D

var pv: int
var is_blueprint := true
var bodycount := 0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	collision_shape_2d.disabled = true
	GLOBAL.network[self] = {}



func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche"):
		place_self()

	# blueprint
	if is_blueprint == true:
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)
	elif is_blueprint == false:
		collision_shape_2d.disabled = false
	
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

func _on_area_2d_area_exited(area: Area2D) -> void:
	if is_blueprint:
		bodycount -= 1
func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_blueprint and !area.get_parent().is_blueprint:
		bodycount += 1
	elif !area.get_parent().is_blueprint:
		print(area.get_parent().linear_velocity)
		if area.get_parent().linear_velocity.length() >= Vector2(0,700).length():
			print("aie")
