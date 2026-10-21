extends Panel
@onready var ressources = {"charbon": $VBoxContainer/charbon,"bois": $VBoxContainer/bois,"pierre": $VBoxContainer/pierre,"brique": $VBoxContainer/brique,"minerai_fer": $VBoxContainer/minerai_fer,"lingot_fer": $VBoxContainer/lingot_fer,"plaque_fer": $VBoxContainer/plaque_fer,"cuivre": $VBoxContainer/cuivre,"etain": $VBoxContainer/etain,"bronze": $VBoxContainer/bronze,"engrenage_bronze": $VBoxContainer/engrenage_bronze,"lingot_acier": $VBoxContainer/lingot_acier,"barre_acier": $VBoxContainer/barre_acier,"minerai_gluantite": $VBoxContainer/minerai_gluantite,"lingot_gluantite": $VBoxContainer/lingot_gluantite,"minerai_topaxium": $VBoxContainer/minerai_topaxium,"lingot_topaxium": $VBoxContainer/lingot_topaxium,"minerai_voidium": $VBoxContainer/minerai_voidium,"lingot_voidium": $VBoxContainer/lingot_voidium}
@onready var ressources2 = {"charbon": $VBoxContainer2/charbon,"bois": $VBoxContainer2/bois,"pierre": $VBoxContainer2/pierre,"brique": $VBoxContainer2/brique,"minerai_fer": $VBoxContainer2/minerai_fer,"lingot_fer": $VBoxContainer2/lingot_fer,"plaque_fer": $VBoxContainer2/plaque_fer,"cuivre": $VBoxContainer2/cuivre,"etain": $VBoxContainer2/etain,"bronze": $VBoxContainer2/bronze,"engrenage_bronze": $VBoxContainer2/engrenage_bronze,"lingot_acier": $VBoxContainer2/lingot_acier,"barre_acier": $VBoxContainer2/barre_acier,"minerai_gluantite": $VBoxContainer2/minerai_gluantite,"lingot_gluantite": $VBoxContainer2/lingot_gluantite,"minerai_topaxium": $VBoxContainer2/minerai_topaxium,"lingot_topaxium": $VBoxContainer2/lingot_topaxium,"minerai_voidium": $VBoxContainer2/minerai_voidium,"lingot_voidium": $VBoxContainer2/lingot_voidium}
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var v_box_container_2: VBoxContainer = $VBoxContainer2
@onready var panel_inv_secours: Panel = $panel_inv_secours

var tween: Tween
var is_detailed := false
func _process(_delta: float) -> void:
	if !is_detailed:
		v_box_container_2.visible = false
		v_box_container.visible = true
		for r in ressources.keys():
			ressources[r].text = "      " + str(GLOBAL.get(r)) + "  |  " + get_parent().get_parent().calculate_production(r)
	else:
		v_box_container_2.visible = true
		v_box_container.visible = false
		for r in ressources2.keys():
			ressources2[r].text = "      " + str(GLOBAL.get(r)) 


func _on_change_button_pressed() -> void:
	if is_detailed:
		is_detailed = false
		self_modulate = Color(1.0, 1.0, 1.0)
		panel_inv_secours.visible = false
	else:
		is_detailed = true
		self_modulate = Color(1.0, 1.0, 1.0, 0.0)
		panel_inv_secours.visible = true

func _on_change_button_mouse_entered() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "offset_transform_position", Vector2(10, 0), 0.1)
	tween.tween_property(self, "offset_transform_position", Vector2(5, 0), 0.1)
func _on_change_button_mouse_exited() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "offset_transform_position", Vector2(0, 0), 0.1)
