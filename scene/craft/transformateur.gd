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
	add_to_group("persist")
	pv_max = pv
	global_position = get_global_mouse_position()
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	var affordable := true
	var minerais = [[minerai, cost], [minerai2, cost2], [minerai3, cost3], [minerai4, cost4]]

	for mat in minerais:
		if mat[0] != "":
			if not GLOBAL.get(mat[0]) >= mat[1]:
				affordable = false

	if affordable:
		for mat in minerais:
			if mat[0] != "":
				GLOBAL.set(mat[0], GLOBAL.get(mat[0]) - mat[1] )
		get_parent().select(self)
	else:
		queue_free()


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche"):
		if is_blueprint:
			place_self()
		elif mouse_overed and not is_blueprint:
			if GLOBAL.selected == self:
				get_parent().unselect()
			else:
				get_parent().unselect()
				get_parent().select(self)
		elif not mouse_overed and GLOBAL.selected == self and not is_blueprint:
			get_parent().unselect()



	#destruction
	if Input.is_action_pressed("click droit"):
		if mouse_overed:
			var refund_mult = 0.5
			if is_blueprint:
				refund_mult = 1
			for mat in [[minerai, cost], [minerai2, cost2], [minerai3, cost3], [minerai4, cost4]]:
				if mat[0] != "":
					GLOBAL.set(mat[0], GLOBAL.get(mat[0]) + mat[1]*refund_mult)
			SIGNAL.emit_signal("defreeze")
			if GLOBAL.selected == self:
				get_parent().unselect()
			$"../banger".play()
			queue_free()
		sleeping = false
	if pv <= 0:
		SIGNAL.emit_signal("defreeze")
		if GLOBAL.selected == self:
			get_parent().unselect()
		queue_free()


	# blueprint
	if is_blueprint:
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)

	# regarder si posibilité sde placer pour la couleur
	if is_blueprint:
		if bodycount == 0:
			sprite_2d.self_modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.self_modulate = Color(0.729, 0.114, 0.267, 0.565)

#une fois le blueplrint fini placer
func place_self():
	if bodycount == 0:
		sprite_2d.self_modulate = Color(1, 1, 1, 1)
		get_parent().unselect()
		if (position.x > position_x_gauche and position.x < position_x_droite) and (position.y > position_y_haut and position.y < position_y_bas):
			sprite_2d.play("default")
		else :
			sprite_2d.play("arret")
		electrical_strenght()
		production_timer.start()
		$"../tinker".play()
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


func tooltipify():
	var res := "Processer\n"
	res = res + "hp: "+str(pv)+"/"+str(pv_max)
	res = res + "\nproduction time: "+str(production_timer.wait_time)+"s"
	return res
