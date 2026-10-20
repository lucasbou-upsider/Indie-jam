extends RigidBody2D


var is_blueprint := true
var bodycount := 0
var mouse_overed := false
var is_powered := false
@onready var collision_shape_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var production_timer: Timer = $ProductionTimer

@export var pv := 10
@export var elec_efficacity = [2, 5, 10] 
@export_category("cout de construction")
@export var cost := 0
@export var minerai := ""
@export var cost2 := 0
@export var minerai2 := ""
@export var cost3 := 0
@export var minerai3 := ""
@export var cost4 := 0
@export var minerai4 := ""
@export_category("demande")
@export var demande := ""
@export var cout_demande := 0
@export var demande2 := ""
@export var cout_demande2 := 0
@export_category("production")
@export var minerai_produit := ""
@export var production = 0
@export_category("specificité ?")
@export var position_x: int
@export var position_y: int


func defreeze():
	sleeping = false
func _ready() -> void:
	electrical_strenght()
	production_timer.start()
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	if GLOBAL.get(minerai) and GLOBAL.get(minerai2) and GLOBAL.get(minerai3) and GLOBAL.get(minerai4):
		if GLOBAL.get(minerai) >= cost and GLOBAL.get(minerai2) >= cost2 and GLOBAL.get(minerai3) >= cost3 and GLOBAL.get(minerai4) >= cost4:
			GLOBAL.set(minerai, GLOBAL.get(minerai) - cost)
			GLOBAL.set(minerai2, GLOBAL.get(minerai2) - cost2)
			GLOBAL.set(minerai3, GLOBAL.get(minerai3) - cost3)
			GLOBAL.set(minerai4, GLOBAL.get(minerai4) - cost4)
		else:
			queue_free()
	elif GLOBAL.get(minerai) and GLOBAL.get(minerai2) and GLOBAL.get(minerai3):
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
			if GLOBAL.get(minerai):
				GLOBAL.set(minerai, GLOBAL.get(minerai) + cost/2)
			if GLOBAL.get(minerai2):
				GLOBAL.set(minerai2, GLOBAL.get(minerai2) + cost2/2)
			if GLOBAL.get(minerai3):
				GLOBAL.set(minerai3, GLOBAL.get(minerai3) + cost3/2)
			if GLOBAL.get(minerai4):
				GLOBAL.set(minerai4, GLOBAL.get(minerai4) + cost4/2)
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
		is_blueprint = false
		collision_shape_2d.disabled = false


func electrical_strenght():
	production_timer.wait_time = elec_efficacity.get(GLOBAL.calcul_electrical_strength(position.x))



func _on_production_timer_timeout() -> void:
	electrical_strenght()
	if GLOBAL.get(demande) and GLOBAL.get(demande2):
		if GLOBAL.get(demande) >= cout_demande and GLOBAL.get(demande2) >= cout_demande2:
			GLOBAL.set(demande, GLOBAL.get(demande) - cout_demande)
			GLOBAL.set(demande2, GLOBAL.get(demande2) - cout_demande2)
			GLOBAL.set(minerai_produit, GLOBAL.get(minerai_produit) + production)
	else:
		if GLOBAL.get(demande) >= cout_demande:
			GLOBAL.set(demande, GLOBAL.get(demande) - cout_demande)
			print(GLOBAL.get(minerai_produit))
			print(production)
			GLOBAL.set(minerai_produit, GLOBAL.get(minerai_produit) + production)


func _on_clearance_area_area_entered(area: Area2D) -> void:
	#degats
	if !is_blueprint and area.name != "verif_Area2D":
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= GLOBAL.degats[ area.get_parent().type ]
			if area.get_parent().type == "anti":
				area.get_parent().queue_free()
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
