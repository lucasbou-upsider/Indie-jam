extends RigidBody2D

@export var pv := 10
var is_blueprint := true
var bodycount := 0
var cost = 200
var cost2 = 100
var cost3 = 100
var elec_efficacity = [2, 5, 10] 
var mouse_overed := false
var is_powered := false
@onready var collision_shape_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var production_timer: Timer = $ProductionTimer


func defreeze():
	sleeping = false
func _ready() -> void:
	electrical_strenght()
	production_timer.start()
	SIGNAL.connect("defreeze", defreeze)
	if GLOBAL.bois >= cost and GLOBAL.pierre >= cost2 and GLOBAL.brique >= cost3:
		GLOBAL.bois -= cost 
		GLOBAL.pierre -= cost2
		GLOBAL.brique -= cost3
		GLOBAL.network[self] = {}
		update_powered()
	else:
		SIGNAL.emit_signal("defreeze")
		queue_free()


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche") and is_blueprint:
		place_self()
		
	elif Input.is_action_just_pressed("click gauche") and mouse_overed and !is_blueprint:
		if (GLOBAL.selected != null) and (GLOBAL.selected != self) and (not GLOBAL.selected in GLOBAL.network[self].keys()):
			GLOBAL.connect_buildings(GLOBAL.selected, self)
			GLOBAL.selected = null
		elif GLOBAL.selected == self:
			GLOBAL.selected = null
		elif GLOBAL.selected == null:
			GLOBAL.selected = self
		elif GLOBAL.selected == null:
			GLOBAL.selected = self
	
	if mouse_overed:
		if Input.is_action_just_pressed("1"):
			GLOBAL.selected = self
		elif Input.is_action_just_pressed("2"):
			GLOBAL.selected2 = self
		elif Input.is_action_just_pressed("4"):
			print(GLOBAL.is_powered(self))

#destruction
	if Input.is_action_just_pressed("click droit"):
		if mouse_overed:
			GLOBAL.bois += cost/2
			GLOBAL.pierre += cost2/2
			GLOBAL.brique += cost3/2
			SIGNAL.emit_signal("defreeze")
			for node in GLOBAL.network[self].keys():
				GLOBAL.disconnect_building(self, node)
			GLOBAL.network.erase(self)
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
		is_blueprint = false
		collision_shape_2d.disabled = false


func electrical_strenght():
	production_timer.wait_time = elec_efficacity.get(GLOBAL.calcul_electrical_strength(position.x))


func update_powered():
	if GLOBAL.is_powered(self):
		if not is_powered:
			is_powered = true
			for node in GLOBAL.network.keys():
				node.update_powered()
		label.text = "on"
	
	else:
		if is_powered:
			is_powered = false
			for node in GLOBAL.network.keys():
				node.update_powered()
		label.text = "off"

func _on_production_timer_timeout() -> void:
	electrical_strenght()
	if GLOBAL.lingot_fer >= 1:
		GLOBAL.lingot_fer -= 1
		GLOBAL.plaque_fer += 1


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
