extends Panel

var init_pos: Vector2
var final_pos: Vector2
var tween : Tween
var is_view := false

func _ready() -> void:
	init_pos = global_position
	final_pos = init_pos + Vector2(0 , -206)
	if OS.has_feature("mobile"):
		$Button.visible = true
	elif OS.has_feature("pc"):
		$Button.visible = false


func _on_mouse_entered() -> void:
	if OS.has_feature("pc"):
		is_view = true
		if tween : tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", final_pos + Vector2(0,-5), 0.1)
		tween.tween_property(self, "global_position", final_pos, 0.1)

func _on_mouse_exited() -> void:
	if OS.has_feature("pc"):
		is_view = false
		if tween : tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", init_pos, 0.1)


func _on_button_pressed() -> void:
	if is_view == false:
		is_view = true
		if tween : tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", final_pos + Vector2(0,-5), 0.1)
		tween.tween_property(self, "global_position", final_pos, 0.1)
	else:
		is_view = false
		if tween : tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position", init_pos, 0.1)
