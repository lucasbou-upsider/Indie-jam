extends RigidBody2D


@onready var collision_polygon_2d: CollisionPolygon2D = $PhysicsShape
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_blueprint := true
@export var pv = 0
var bodycount = 0
var mouse_overed := false


@export_category("cout de construction")
@export var cost := 0
@export var minerai := ""
@export var cost2 := 0
@export var minerai2 := ""
@export var cost3 := 0
@export var minerai3 := ""

func defreeze():
	sleeping = false
func _ready() -> void:
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if GLOBAL.get(minerai) and GLOBAL.get(minerai2) and GLOBAL.get(minerai3):
		if GLOBAL.get(minerai) >= cost and GLOBAL.get(minerai2) >= cost2 and GLOBAL.get(minerai3) >= cost3 :
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
			GLOBAL.set(minerai2, GLOBAL.get(minerai2) - cost2)
			GLOBAL.set(minerai3, GLOBAL.get(minerai3) - cost3)
		else:
			queue_free()
	elif GLOBAL.get(minerai) and GLOBAL.get(minerai2):
		if GLOBAL.get(minerai) >= cost and GLOBAL.get(minerai2) >= cost2 :
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
			GLOBAL.set(minerai2, GLOBAL.get(minerai2) - cost2)
		else:
			queue_free()
	elif GLOBAL.get(minerai):
		if GLOBAL.get(minerai) >= cost:
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
		else:
			queue_free()


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche") and is_blueprint:
		place_self()

	#destruction
	if Input.is_action_just_pressed("click droit"):
		if mouse_overed:
			if GLOBAL.get(minerai):
				GLOBAL.set(minerai, GLOBAL.get(minerai) + cost/2)
			if GLOBAL.get(minerai2):
				GLOBAL.set(minerai2, GLOBAL.get(minerai2) + cost2/2)
			if GLOBAL.get(minerai3):
				GLOBAL.set(minerai3, GLOBAL.get(minerai3) + cost3/2)
			SIGNAL.emit_signal("defreeze")
			queue_free()
		sleeping = false
	if pv == 0:
		SIGNAL.emit_signal("defreeze")
		queue_free()



	#regarde si l'objet est en blueprint ou pas
	if is_blueprint:
		collision_polygon_2d.disabled = true
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)
	elif is_blueprint == false:
		collision_polygon_2d.disabled = false

	#blueprint
	if is_blueprint:
		if bodycount == 0:
			sprite_2d.modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.modulate = Color(0.729, 0.114, 0.267, 0.565)
	else:
		sprite_2d.modulate = Color(1.0, 0.98, 0.984, 0.98)

#une fois le blueplrint fini placer
func place_self():
	if bodycount == 0:
		is_blueprint = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint and area.name != "verif_Area2D":
		bodycount += 1
	if !is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= 1
func _on_area_2d_area_exited(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint:
		bodycount -= 1

#verifie que la souris est sur le batiment
func _on_area_2d_mouse_entered() -> void:
	mouse_overed = true
func _on_area_2d_mouse_exited() -> void:
	mouse_overed = false
