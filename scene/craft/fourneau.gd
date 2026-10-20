extends RigidBody2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var production_timer: Timer = $ProductionTimer

var is_blueprint := true
@export var elec_efficacity = [2, 5, 10]
@export var pv = 10
@export var cost = 200
var bodycount = 0
var mouse_overed := false

func defreeze():
	sleeping = false
func _ready() -> void:
	electrical_strenght()
	production_timer.start()
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if GLOBAL.brique >= cost:
		GLOBAL.brique -= cost
	else:
		queue_free()


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche") and is_blueprint:
		place_self()


	#destruction
	if Input.is_action_just_pressed("click droit"):
		if mouse_overed:
			GLOBAL.brique += cost/2
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

func electrical_strenght():
	production_timer.wait_time = elec_efficacity.get(GLOBAL.calcul_electrical_strength(position.x))



func _on_production_timer_timeout() -> void:
	electrical_strenght()
	if GLOBAL.minerai_fer >= 1 and GLOBAL.bois:
		GLOBAL.minerai_fer -= 1
		GLOBAL.lingot_fer += 1


#verifie que la souris est sur le batiment
func _on_clearance_area_mouse_entered() -> void:
	mouse_overed = true
func _on_clearance_area_mouse_exited() -> void:
	mouse_overed = false


func _on_clearance_area_area_entered(area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint :
		bodycount += 1
	if !is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= 1
func _on_clearance_area_area_exited(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint:
		bodycount -= 1

#verifie que la souris est sur le batiment
func _on_area_2d_mouse_entered() -> void:
	mouse_overed = true
func _on_area_2d_mouse_exited() -> void:
	mouse_overed = false
