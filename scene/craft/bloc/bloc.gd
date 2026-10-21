extends RigidBody2D
class_name bloc
@warning_ignore_start("integer_division")

@onready var collision_polygon_2d: CollisionPolygon2D = $PhysicsShape
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_blueprint := true

var bodycount = 0
var mouse_overed := false
var pv_max

@export var pv = 0
@export var is_voidium := false
@export_category("cout de construction")
@export var cost := 0
@export var minerai := ""
@export var cost2 := 0
@export var minerai2 := ""
@export var cost3 := 0
@export var minerai3 := ""

func defreeze():
	sleeping = false

func _ready() -> void:
	pv_max = pv
	SIGNAL.connect("defreeze", defreeze)
	#cout du batiments
	var affordable := true
	var minerais = [[minerai, cost], [minerai2, cost2], [minerai3, cost3]]
	
	for mat in minerais:
		if mat[0] != "":
			if not GLOBAL.get(mat[0]) >= mat[1]:
				affordable = false
	
	if affordable:
		for mat in minerais:
			if mat[0] != "":
				GLOBAL.set(mat[0], GLOBAL.get(mat[0]) - mat[1] )
		GLOBAL.select(self)
	else:
		queue_free()


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche"):
		if is_blueprint:
			place_self()
		elif mouse_overed:
			if GLOBAL.selected == self:
				GLOBAL.unselect()
			else:
				GLOBAL.select(self)




	#destruction
	if Input.is_action_pressed("click droit"): 
		if mouse_overed:
			var refund_mult = 0.5
			if is_blueprint:
				refund_mult = 1
			for mat in [[minerai, cost], [minerai2, cost2], [minerai3, cost3]]:
				if mat[0] != "":
					GLOBAL.set(mat[0], GLOBAL.get(mat[0]) + mat[1]*refund_mult)
			SIGNAL.emit_signal("defreeze")
			queue_free()
		sleeping = false
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

	#blueprint
	if is_blueprint:
		if bodycount == 0:
			sprite_2d.modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.modulate = Color(0.729, 0.114, 0.267, 0.565)

#une fois le blueplrint fini placer
func place_self():
	if bodycount == 0:
		sprite_2d.self_modulate = Color(1, 1, 1, 1)
		GLOBAL.unselect()
		is_blueprint = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint and area.name != "verif_Area2D":
		bodycount += 1
	if !is_blueprint:
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
