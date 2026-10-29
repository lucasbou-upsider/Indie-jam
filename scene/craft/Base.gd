extends RigidBody2D
class_name Base

var pv_max: int = 100
var pv: int = GLOBAL.base_pv
var is_blueprint := true
var bodycount := 0
var mouse_overed := false
@onready var collision_polygon_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

#defreeze pour les signaux

func defreeze():
	sleeping = false

func save():
	var save_dict = {
		"filename": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"pos_x": position.x,
		"pos_y": position.y,
		"is_blueprint": is_blueprint,
		"rotation": rotation,
		"pv": pv,
	}
	return save_dict

func _ready() -> void:
	add_to_group("persist")
	get_parent().select(self)
	SIGNAL.connect("defreeze", defreeze)


func _process(_delta: float) -> void:

	#pv connecter pour foreuse
	GLOBAL.base_pv = pv
	GLOBAL.mouse_busy = false

	# Input
	if Input.is_action_just_pressed("click gauche"):
		if is_blueprint:
			if GLOBAL.is_paused == false:
				place_self()
		elif mouse_overed and not is_blueprint:
			if GLOBAL.selected == self:
				get_parent().unselect()
			else:
				get_parent().unselect()
				get_parent().select(self)
		elif not mouse_overed and GLOBAL.selected == self and not is_blueprint:
			get_parent().unselect()

	# blueprint
	if is_blueprint == true:
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)

	# regarder si posibilité sde placer pour la couleur
	if is_blueprint:
		if bodycount == 0:
			sprite_2d.self_modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.self_modulate = Color(0.729, 0.114, 0.267, 0.565)

func place_self():
	if bodycount == 0:
		$auto_pose.stop()
		global_position = get_global_mouse_position()
		sprite_2d.self_modulate = Color(1, 1, 1, 1)
		is_blueprint = false
		$"../tinker".play()
		collision_polygon_2d.disabled = false
		get_parent().unselect()

func _on_area_2d_area_exited(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint:
		bodycount -= 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	#degats
	if !is_blueprint:
		if area.get_parent().get_parent().name == "kayou_spawn":
			pv -= GLOBAL.degats[ area.get_parent().type ]
			if area.get_parent().type == "anti":
				area.get_parent().queue_free()
	#regarder si possible de placer
	if is_blueprint and area.name != "verif_Area2D":
		bodycount += 1

func _on_area_2d_mouse_entered() -> void:
	mouse_overed = true
func _on_area_2d_mouse_exited() -> void:
	mouse_overed = false

func tooltipify():
	var res := "Base\n"
	res = res + "hp: "+str(pv)+"/"+str(pv_max)
	return res

#POUR NE PAS FAIRE CRASH LORS DU MOBILE
func destroy():
	pass

func _on_auto_pose_timeout() -> void:
	place_self()
