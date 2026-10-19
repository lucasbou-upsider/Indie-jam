extends RigidBody2D

var pv := 10
var is_blueprint := true
var bodycount := 0
@onready var collision_shape_2d: CollisionPolygon2D = $PhysicsShape
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	collision_shape_2d.disabled = true



func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche"):
		place_self()

	# blueprint
	if is_blueprint:
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)
	
	# regarder si posibilité sde placer pour la couleur
	if is_blueprint:
		if bodycount == 0:
			sprite_2d.modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.modulate = Color(0.729, 0.114, 0.267, 0.565)
	else:
		sprite_2d.modulate = Color(1.0, 0.98, 0.984, 0.98)

func place_self():
	if bodycount == 0:
		is_blueprint = false
		collision_shape_2d.disabled = false

func _on_area_2d_area_exited(_area: Area2D) -> void:
	if is_blueprint:
		bodycount -= 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_blueprint:
		bodycount += 1
	elif not is_blueprint and not area.get_parent().is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= 1


func _on_production_timer_timeout() -> void:
	if GLOBAL.pierre >= 1:
		GLOBAL.pierre -= 1
		GLOBAL.brique += 1
