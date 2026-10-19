extends Node2D

const KAYOU = preload("uid://btukiu61dok1y")


func _ready() -> void:
	wave(200,0)

func _process(_delta: float) -> void:
	pass

func wave(wave_number: int, strength):
	if strength == 0:
		for i in range(wave_number):
			spawn_kayou()


func spawn_kayou():
	var kayou_pos_x = randf_range(-10000,10000)
	var kayouinst = KAYOU.instantiate()
	kayouinst.global_position = Vector2(kayou_pos_x, position.y)
	add_child(kayouinst)
