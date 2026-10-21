extends Node2D
@warning_ignore_start("integer_division")


@onready var vague_timer: Timer = $vague_Timer
@onready var label_time_left: Label = $"../Interface/Panel_vague/time_left"
@warning_ignore("shadowed_global_identifier") @onready var kayou_spawn: Node2D = $"../kayou_spawn"

var vague_number = 0
var nbr_meteorite = [100, 200, 250, 250, 300, 400]

func _ready() -> void:
	vague_timer.start()

func _process(_delta: float) -> void:
	label_time_left.text = str(int(vague_timer.time_left))

func _on_vague_timer_timeout() -> void:
	print("vague de " + str(nbr_meteorite[vague_number%nbr_meteorite.size()]) + " meteorites ")
	kayou_spawn.wave(nbr_meteorite[vague_number%nbr_meteorite.size()], int(vague_number/nbr_meteorite.size()))
	vague_number += 1
	await get_tree().create_timer(6).timeout
	vague_timer.start()
