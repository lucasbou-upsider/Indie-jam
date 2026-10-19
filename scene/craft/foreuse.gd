extends RigidBody2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_blueprint := true
var pv = 10
var bodycount = 0

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	# Input
	if Input.is_action_just_pressed("click gauche"):
		place_self()


	if is_blueprint:
		collision_polygon_2d.disabled = true
		global_position = get_global_mouse_position()
		linear_velocity = Vector2(0,0)
	elif is_blueprint == false:
		collision_polygon_2d.disabled = false
		if ray_cast_2d.is_colliding():
			ray_cast_2d.enabled = false
			print("fer")
			timer.start()

	if is_blueprint:
		if bodycount == 0:
			sprite_2d.modulate = Color(1.0, 1.0, 1.0, 0.494)
		else:
			sprite_2d.modulate = Color(0.729, 0.114, 0.267, 0.565)
	else:
		sprite_2d.modulate = Color(1.0, 0.98, 0.984, 0.98)

func place_self():
	if bodycount == 0:
		is_blueprint = false

func _on_timer_timeout() -> void:
	GLOBAL.pierre += 1
	ray_cast_2d.enabled = true


func _on_area_2d_area_entered(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint :
		bodycount += 1
func _on_area_2d_area_exited(_area: Area2D) -> void:
	#regarder si possible de placer
	if is_blueprint:
		bodycount -= 1
