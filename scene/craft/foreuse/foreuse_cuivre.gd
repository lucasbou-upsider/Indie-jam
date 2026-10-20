extends RigidBody2D
@onready var collision_polygon_2d: CollisionPolygon2D = $PhysicsShape
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var production_timer: Timer = $production_timer

var is_blueprint := true
var elec_efficacity = [1, 3, 5]
@export var pv = 10
var bodycount = 0
var mouse_overed := false
var cost = 20
var cost2 = 100 
var is_powered := false

func defreeze():
	sleeping = false
func _ready() -> void:
	electrical_strenght()
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if GLOBAL.plaque_fer >= cost and GLOBAL.brique >= cost2:
		GLOBAL.plaque_fer -= cost
		GLOBAL.brique -= cost2
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
	
	if mouse_overed:
		if Input.is_action_just_pressed("1"):
			GLOBAL.selected = self
		elif Input.is_action_just_pressed("2"):
			GLOBAL.selected2 = self
		elif Input.is_action_just_pressed("4"):
			print(GLOBAL.is_powered(self))
			print(is_powered)

	#destruction
	if Input.is_action_just_pressed("click droit"):
		if mouse_overed:
			GLOBAL.plaque_fer += cost/2
			GLOBAL.brique += cost2/2
			SIGNAL.emit_signal("defreeze")
			for node in GLOBAL.network[self].keys():
				GLOBAL.disconnect_building(self, node)
			GLOBAL.network.erase(self)
			queue_free()
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
		if ray_cast_2d.is_colliding():
			if ray_cast_2d.get_collider().get("pv"):
				ray_cast_2d.get_collider().pv -= 1
			ray_cast_2d.enabled = false
			sprite_2d.play("new_animation")
			production_timer.start()

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

#production
func _on_timer_timeout() -> void:
	electrical_strenght()
	sprite_2d.play("arret")
	GLOBAL.cuivre += 1
	ray_cast_2d.enabled = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint :
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
