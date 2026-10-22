extends Node2D
@warning_ignore_start("integer_division")


@onready var vague_timer: Timer = $vague_Timer
@onready var label_time_left: RichTextLabel = $"../Interface/Panel_vague/time_left"
@onready var warner: AudioStreamPlayer = $warner
@warning_ignore("shadowed_global_identifier") @onready var kayou_spawn: Node2D = $"../kayou_spawn"

var vague_number = 0
var nbr_meteorite = [100, 200, 250, 250, 300]

func _ready() -> void:
	vague_timer.start()

func _process(_delta: float) -> void:
	if vague_timer.time_left <= 50 and 49 <= vague_timer.time_left:
		if not warner.has_stream_playback():
			warner.play()
		label_time_left.text = "[shake rate=15 level=7]" + str(int(vague_timer.time_left))
		label_time_left.self_modulate = Color(0.869, 0.0, 0.09)
	elif vague_timer.time_left <= 100 and 99 <= vague_timer.time_left:
		if not warner.has_stream_playback():
			warner.play()
		label_time_left.text = "[shake rate=10 level=4]" + str(int(vague_timer.time_left))
		label_time_left.self_modulate = Color(1.0, 0.476, 0.428)
	elif vague_timer.time_left > 100:
		label_time_left.text = str(int(vague_timer.time_left))
		label_time_left.self_modulate = Color(1.0, 1.0, 1.0)

func _on_vague_timer_timeout() -> void:
	print("vague de " + str(nbr_meteorite[vague_number%nbr_meteorite.size()]) + " meteorites ")
	get_parent().camera.screen_shake(0, 7, -2)
	kayou_spawn.wave(nbr_meteorite[vague_number%nbr_meteorite.size()], int(vague_number/nbr_meteorite.size()))
	vague_number += 1
	await get_tree().create_timer(6).timeout
	vague_timer.start()
