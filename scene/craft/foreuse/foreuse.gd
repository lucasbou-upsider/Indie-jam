extends RigidBody2D
class_name foreuse
@warning_ignore_start("integer_division")

@onready var collision_polygon_2d: CollisionPolygon2D = $PhysicsShape
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var production_timer: Timer = $production_timer

var is_blueprint := true
@export var pv = 10
@export var elec_efficacity = [1, 3, 10]
@export_category("cout de construction")
@export var cost := 0
@export var minerai := ""
@export var cost2 := 0
@export var minerai2 := ""
@export var cost3 := 0
@export var minerai3 := ""
@export var cost4 := 0
@export var minerai4 := ""
@export_category("production")
@export var production = 0
@export var minerai_produit := ""
@export var production2 = 0
@export var minerai_produit2 := ""

var pv_max := 0
var bodycount = 0
var mouse_overed := false


func defreeze():
	sleeping = false

func _ready() -> void:
	pv_max = pv
	GLOBAL.mouse_busy = true
	electrical_strenght()
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if minerai != "" and minerai2 != "" and minerai3 != "" and minerai4 != "":
		if GLOBAL.get(minerai) >= cost and GLOBAL.get(minerai2) >= cost2 and GLOBAL.get(minerai3) >= cost3 and GLOBAL.get(minerai4) >= cost4:
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
			GLOBAL.set(minerai2, GLOBAL.get(minerai2) - cost2)
			GLOBAL.set(minerai3, GLOBAL.get(minerai3) - cost3)
			GLOBAL.set(minerai4, GLOBAL.get(minerai4) - cost4)
		else:
			queue_free()
			GLOBAL.mouse_busy = false
	elif minerai != "" and minerai2 != "" and minerai3 != "" :
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
			if minerai4 != "":
				GLOBAL.set(minerai4, GLOBAL.get(minerai4) + cost4/2)
			SIGNAL.emit_signal("defreeze")
			queue_free()
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
		if ray_cast_2d.is_colliding():
			if ray_cast_2d.get_collider().get("pv"):
				ray_cast_2d.get_collider().pv -= 1
			ray_cast_2d.enabled = false
			sprite_2d.play("new_animation")
			production_timer.start()

	#blueprint
	if is_blueprint:
		if bodycount == 0:
			print(sprite_2d.self_modulate)
			sprite_2d.self_modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.self_modulate = Color(0.729, 0.114, 0.267, 0.565)
	else:
		sprite_2d.self_modulate = Color(1.0, 0.98, 0.984, 0.98)

#une fois le blueplrint fini placer
func place_self():
	if bodycount == 0:
		GLOBAL.mouse_busy = false
		electrical_strenght()
		production_timer.start()
		is_blueprint = false

func electrical_strenght():
	production_timer.wait_time = elec_efficacity.get(GLOBAL.calcul_electrical_strength(position.x))

#production
func _on_timer_timeout() -> void:
	electrical_strenght()
	sprite_2d.play("arret")

	GLOBAL.set(minerai_produit, GLOBAL.get(minerai_produit) + production) 
	if GLOBAL.get(minerai_produit2):
		GLOBAL.set(minerai_produit2, GLOBAL.get(minerai_produit2) + production2) 
	ray_cast_2d.enabled = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint and area.name != "verif_Area2D":
		bodycount += 1
	if !is_blueprint and area.name != "verif_Area2D":
		if area.get_parent().get_parent().name == "kayou_spawn":
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
