extends Control

@onready var menu_base: Control = $menu_base
@onready var options_menu: Control = $options_menu

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")


func _on_options_pressed() -> void:
	menu_base.visible = false
	options_menu.visible = true


func _on_back_pressed() -> void:
	menu_base.visible = true
	options_menu.visible = false
