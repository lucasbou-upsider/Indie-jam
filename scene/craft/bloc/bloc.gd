extends RigidBody2D
class_name bloc
@warning_ignore_start("integer_division")

@onready var collision_polygon_2d: CollisionPolygon2D = $PhysicsShape
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_blueprint := true
@export var pv = 0
var bodycount = 0
var mouse_overed := false
var pv_max

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
	pv_max = pv
	GLOBAL.mouse_busy = true
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if minerai != "" and minerai2 != "" and minerai3 != "":
		if GLOBAL.get(minerai) >= cost and GLOBAL.get(minerai2) >= cost2 and GLOBAL.get(minerai3) >= cost3 :
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
			GLOBAL.set(minerai2, GLOBAL.get(minerai2) - cost2)
			GLOBAL.set(minerai3, GLOBAL.get(minerai3) - cost3)
		else:
			queue_free()
			GLOBAL.mouse_busy = false
	elif minerai != "" and minerai2 != "":
		if GLOBAL.get(minerai) >= cost and GLOBAL.get(minerai2) >= cost2 :
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
			GLOBAL.set(minerai2, GLOBAL.get(minerai2) - cost2)
		else:
			queue_free()
			GLOBAL.mouse_busy = false
	elif minerai != "":
		if GLOBAL.get(minerai) >= cost:
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
		else:
			queue_free()
			GLOBAL.mouse_busy = false


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche") and is_blueprint:
		place_self()

	#destruction
	if Input.is_action_pressed("click droit"):
		if mouse_overed:
			if minerai != "":
				GLOBAL.set(minerai, GLOBAL.get(minerai) + cost/2)
			if minerai2 != "":
				GLOBAL.set(minerai2, GLOBAL.get(minerai2) + cost2/2)
			if minerai3 != "":
				GLOBAL.set(minerai3, GLOBAL.get(minerai3) + cost3/2)
			SIGNAL.emit_signal("defreeze")
			queue_free()
		sleeping = false
	if pv <= 0:
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
		GLOBAL.mouse_busy = false
		is_blueprint = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint and area.name != "verif_Area2D":
		bodycount += 1
	if !is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			var pv_float:float = pv
			var pv_max_float:float = pv_max
			var shader := sprite_2d.material
			var shader_value:float = (pv_float/pv_max_float)*0.8+0.2
			print(shader)
			shader.set_shader_parameter("dissolve_value", shader_value)
			#shader.set_shader_parameter("dissolve_value", shader_value)
			pv -= GLOBAL.degats[ area.get_parent().type ]
			if area.get_parent().type == "anti":
				area.get_parent().queue_free()
func _on_area_2d_area_exited(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint:
		bodycount -= 1

#verifie que la souris est sur le batiment
func _on_area_2d_mouse_entered() -> void:
	mouse_overed = true
func _on_area_2d_mouse_exited() -> void:
	mouse_overed = false
