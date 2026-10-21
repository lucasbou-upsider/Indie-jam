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
	electrical_strenght()
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	
	var affordable := true
	var minerais = [[minerai, cost], [minerai2, cost2], [minerai3, cost3], [minerai4, cost4]]
	
	for mat in minerais:
		if mat[0] != "":
			if GLOBAL.get(mat[0]) < mat[1]:
				affordable = false
	if affordable:
		for mat in minerais:
			if mat[0] != "":
				GLOBAL.set(mat[0], GLOBAL.get(mat[0]) - mat[1] )
		get_parent().select(self)
	else:
		queue_free()


func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("click gauche"):
		if is_blueprint:
			place_self()
		elif mouse_overed:
			if GLOBAL.selected == self:
				get_parent().unselect()
			else:
				get_parent().unselect()
				get_parent().select(self)
		elif not mouse_overed and GLOBAL.selected:
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
			queue_free()
	if pv <= 0:
		SIGNAL.emit_signal("defreeze")
		if GLOBAL.selected == self:
			get_parent().unselect()
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
			sprite_2d.self_modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.self_modulate = Color(0.729, 0.114, 0.267, 0.565)

#une fois le blueplrint fini placer
func place_self():
	if bodycount == 0:
		sprite_2d.self_modulate = Color(1, 1, 1, 1)
		get_parent().unselect()
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

func tooltipify():
	var res := "Drill\n"
	res = res + "hp: "+str(pv)+"/"+str(pv_max)
	res = res + "\nproduction time: "+str(production_timer.wait_time)+"s"
	return res
