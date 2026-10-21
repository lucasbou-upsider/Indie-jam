extends Panel
@onready var ressources = {"charbon": $VBoxContainer/charbon,"bois": $VBoxContainer/bois,"pierre": $VBoxContainer/pierre,"brique": $VBoxContainer/brique,"minerai_fer": $VBoxContainer/minerai_fer,"lingot_fer": $VBoxContainer/lingot_fer,"plaque_fer": $VBoxContainer/plaque_fer,"cuivre": $VBoxContainer/cuivre,"etain": $VBoxContainer/etain,"bronze": $VBoxContainer/bronze,"engrenage_bronze": $VBoxContainer/engrenage_bronze,"lingot_acier": $VBoxContainer/lingot_acier,"barre_acier": $VBoxContainer/barre_acier,"minerai_gluantite": $VBoxContainer/minerai_gluantite,"lingot_gluantite": $VBoxContainer/lingot_gluantite,"minerai_topaxium": $VBoxContainer/minerai_topaxium,"lingot_topaxium": $VBoxContainer/lingot_topaxium,"minerai_voidium": $VBoxContainer/minerai_voidium,"lingot_voidium": $VBoxContainer/lingot_voidium}

func _process(_delta: float) -> void:
	for r in ressources.keys():
		if GLOBAL.get(r) > 9999: GLOBAL.set(r, 9999)
		ressources[r].text = "      " + str(GLOBAL.get(r)) + "  |  " + get_parent().get_parent().calculate_production(r)
