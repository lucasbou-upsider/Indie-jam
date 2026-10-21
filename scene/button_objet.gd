extends Button

var panel_info
@export var init_position:Vector2
var tween:Tween


func _ready() -> void:
	panel_info = get_child(0)
	print(panel_info)
	#panel_info.visible = false
	init_position = panel_info.global_position
	print(init_position)
	#panel_info.global_position += Vector2(100, 0)

func _on_mouse_entered() -> void:
	panel_info.visible = true
	tween = create_tween()
	tween.tween_property(panel_info, "global_position", init_position + Vector2(-10, 0), 1)
	tween.tween_property(panel_info, "global_position", init_position + Vector2(-10, 0), 1)
func _on_mouse_exited() -> void:
	#panel_info.visible = false
	pass
