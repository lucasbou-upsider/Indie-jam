extends Node2D

const KAYOU = preload("uid://btukiu61dok1y")


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("a"):
		wave(70, 0)

func wave(wave_number: int, strength):
	if strength == 0:
		for i in range(wave_number):
			spawn_kayou()


func spawn_kayou():
	var kayou_pos_x = randf_range(-1241,1241)
	var kayouinst = KAYOU.instantiate()
	kayouinst.global_position = Vector2(kayou_pos_x, position.y)
	add_child(kayouinst)
