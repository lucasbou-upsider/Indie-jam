extends RigidBody2D

@export var pv := 10
@export var cost = 100
@export var cost2 = 50
@export var elec_efficacity = [2, 5, 10] 

var is_blueprint := true
var bodycount := 0
var mouse_overed := false

@onready var production_timer: Timer = $ProductionTimer
@onready var collision_shape_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label


func defreeze():
	sleeping = false
func _ready() -> void:
	electrical_strenght()
	production_timer.start()
	SIGNAL.connect("defreeze", defreeze)
	if GLOBAL.pierre >= cost and GLOBAL.brique >= cost2:
		GLOBAL.pierre -= cost 
		GLOBAL.bois -= cost2
	else:
		queue_free()


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche") and is_blueprint:
		place_self()


#destruction
	if Input.is_action_just_pressed("click droit"):
		if mouse_overed:
			GLOBAL.pierre += cost/2
			GLOBAL.brique += cost2/2
			SIGNAL.emit_signal("defreeze")
			queue_free()
		sleeping = false
	if pv == 0:
		SIGNAL.emit_signal("defreeze")
		queue_free()


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

#une fois le blueplrint fini placer
func place_self():
	if bodycount == 0:
		if position.x > 400 and position.x < 750:
			sprite_2d.play("default")
		else :
			sprite_2d.play("arret")
		is_blueprint = false
		collision_shape_2d.disabled = false

#force electrique +eloigné -force
func electrical_strenght():
	production_timer.wait_time = elec_efficacity.get(GLOBAL.calcul_electrical_strength(position.x))



func _on_production_timer_timeout() -> void:
	electrical_strenght()
	if position.x > 400 and position.x < 750:
		GLOBAL.bois += 1
		sprite_2d.play("default")
	else :
		sprite_2d.play("arret")


func _on_clearance_area_area_entered(area: Area2D) -> void:
	#degats
	if !is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= 1
	#regarder si possible de placer
	if is_blueprint :
		bodycount += 1
func _on_clearance_area_area_exited(_area: Area2D) -> void:
	if is_blueprint:
		bodycount -= 1


func _on_clearance_area_mouse_entered() -> void:
	mouse_overed = true
func _on_clearance_area_mouse_exited() -> void:
	mouse_overed = false
