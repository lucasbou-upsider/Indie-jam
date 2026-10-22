extends Node2D
class_name kayou_spawn

const KAYOU = preload("uid://btukiu61dok1y")
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func wave(wave_number: int, strength): # 0 <= strength <= 4
	var types := ["base", "base", "base", "base", "base", "base", "base", "base", "gros", "gros", "feu", "feu", "anti", "base", "gros", "feu"]
	for i in range(wave_number):
		var rando = rng.randi_range(0,7)
		spawn_kayou(types[rando+2*strength])


func spawn_kayou(type):
	var kayouinst = KAYOU.instantiate()
	var kayou_pos_x = randf_range(-1241,1241)
	kayouinst.set_type(type)
	kayouinst.global_position = Vector2(kayou_pos_x, position.y)
	add_child(kayouinst)
