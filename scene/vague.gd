extends Node2D

@onready var vague_timer: Timer = $vague_Timer
@onready var label_time_left: Label = $"../Interface/Panel_vague/time_left"
@onready var kayou_spawn: Node2D = $"../kayou_spawn"

var vague_number = 0
var nbr_meteorite_1_phase = [100, 200, 250, 250, 300]

func _ready() -> void:
	vague_timer.start()

func _process(_delta: float) -> void:
	label_time_left.text = str(int(vague_timer.time_left)) 

func _on_vague_timer_timeout() -> void:
	print("vague de " + str(nbr_meteorite_1_phase.get(vague_number)) + " meteorites ")
	kayou_spawn.wave(nbr_meteorite_1_phase.get(vague_number), 0)
	vague_number += 1
	await get_tree().create_timer(6).timeout
	vague_timer.start()
