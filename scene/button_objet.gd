extends Button

var panel_info
var sprite
var tween:Tween
@onready var panel_construction: Panel = $"../../../Panel_construction"


func _ready() -> void:
	sprite = get_child(1)
	panel_info = get_child(0)
	panel_info.offset_transform_enabled = true
	offset_transform_enabled = true
	panel_info.visible = false

func _on_mouse_entered() -> void:
	if tween:tween.kill()
	panel_info.visible = true
	tween = create_tween()
	tween.tween_property(panel_info, "offset_transform_position", Vector2(-10, 0), 0.1)
	tween.tween_property(panel_info, "offset_transform_position", Vector2(0, 0), 0.05)
	tween.parallel().tween_property(self, "offset_transform_scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(self, "offset_transform_scale", Vector2(1.3, 1.3), 0.05)
func _on_mouse_exited() -> void:
	if tween:tween.kill()
	tween = create_tween()
	tween.tween_property(panel_info, "offset_transform_position", Vector2(100, 0), 0.1)
	tween.tween_property(self, "offset_transform_scale", Vector2(1, 1), 0.1)
	panel_info.visible = false
