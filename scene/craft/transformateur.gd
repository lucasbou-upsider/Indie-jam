extends RigidBody2D
class_name transformateur
@warning_ignore_start("integer_division")

var is_blueprint := true
var bodycount := 0
var mouse_overed := false
var is_powered := false
var pv_max := 0
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
@export var position_x_droite: int = 1275
@export var position_x_gauche: int = -1280
@export var position_y_haut: int = -10000
@export var position_y_bas: int = 50


func defreeze():
	sleeping = false

func _ready() -> void:
	pv_max = pv 
	GLOBAL.mouse_busy = true
	global_position = get_global_mouse_position()
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
	elif minerai != "" and minerai2 != "" and minerai3 != "":
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
			if minerai != "" :
				GLOBAL.set(minerai, GLOBAL.get(minerai) + cost/2)
			if minerai2 != "":
				GLOBAL.set(minerai2, GLOBAL.get(minerai2) + cost2/2)
			if minerai3 != "":
				GLOBAL.set(minerai3, GLOBAL.get(minerai3) + cost3/2)
			if minerai4 != "":
				GLOBAL.set(minerai4, GLOBAL.get(minerai4) + cost4/2)
			SIGNAL.emit_signal("defreeze")
			queue_free()
		sleeping = false
	if pv <= 0:
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
		GLOBAL.mouse_busy = false
		if (position.x > position_x_gauche and position.x < position_x_droite) and (position.y > position_y_haut and position.y < position_y_bas):
			sprite_2d.play("default")
		else :
			sprite_2d.play("arret")
		electrical_strenght()
		production_timer.start()
		is_blueprint = false
		collision_shape_2d.disabled = false


func electrical_strenght():
	production_timer.wait_time = elec_efficacity.get(GLOBAL.calcul_electrical_strength(position.x))


func _on_production_timer_timeout() -> void:
	electrical_strenght()
	if (position.x > position_x_gauche and position.x < position_x_droite) and (position.y > position_y_haut and position.y < position_y_bas):
		sprite_2d.play("default")
		if demande != "" and demande2 != "":
			if GLOBAL.get(demande) >= cout_demande and GLOBAL.get(demande2) >= cout_demande2:
				GLOBAL.set(demande, GLOBAL.get(demande) - cout_demande)
				GLOBAL.set(demande2, GLOBAL.get(demande2) - cout_demande2)
				GLOBAL.set(minerai_produit, GLOBAL.get(minerai_produit) + production)
		elif demande != "":
			if GLOBAL.get(demande) >= cout_demande:
				GLOBAL.set(demande, GLOBAL.get(demande) - cout_demande)
				GLOBAL.set(minerai_produit, GLOBAL.get(minerai_produit) + production)
		else:
			GLOBAL.set(minerai_produit, GLOBAL.get(minerai_produit) + production)
	else :
		sprite_2d.play("arret")

func _on_clearance_area_area_entered(area: Area2D) -> void:
	#degats
	if !is_blueprint and area.name != "verif_Area2D":
		if area.get_parent().get_parent().name == "kayou_spawn":
			var pv_float:float = pv
			var pv_max_float:float = pv_max
			var shader := sprite_2d.material as ShaderMaterial
			var shader_value:float = (pv_float/pv_max_float)*0.8+0.2
			shader.set_shader_parameter("dissolve_value", shader_value)
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
