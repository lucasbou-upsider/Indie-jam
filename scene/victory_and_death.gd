extends Control
@onready var death: CanvasLayer = $death
@onready var victory: CanvasLayer = $victory
@onready var interface: CanvasLayer = $"../Interface"

func _process(_delta: float) -> void:
	if GLOBAL.base_pv <= 0:
		death.visible = true
		interface.visible = false


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/title_screen.tscn")
func _on_quit_pressed() -> void:
	get_tree().quit()
