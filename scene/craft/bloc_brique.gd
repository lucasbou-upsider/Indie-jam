extends RigidBody2D

@onready var collision_polygon_2d: CollisionPolygon2D = $PhysicsShape
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_blueprint := true
@export var pv = 30
var bodycount = 0
var mouse_overed := false
@export var cost = 500

func defreeze():
	sleeping = false
func _ready() -> void:
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if GLOBAL.brique >= cost:
		GLOBAL.brique -= cost
		GLOBAL.network[self] = {}
	else:
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
	
	elif Input.is_action_just_pressed("1"):
		GLOBAL.selected = self
		print(GLOBAL.selected == self)
	elif Input.is_action_just_pressed("2"):
		GLOBAL.selected2 = self
		print(GLOBAL.selected2 == self)

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
