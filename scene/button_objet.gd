extends Button

var panel_info

func _ready() -> void:
	panel_info = get_child(0)
	panel_info.visible = false

func _on_mouse_entered() -> void:
	panel_info.visible = true
func _on_mouse_exited() -> void:
	panel_info.visible = false
