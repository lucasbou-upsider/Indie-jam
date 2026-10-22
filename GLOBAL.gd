extends Node

#pv
var tool_tip: RichTextLabel
var base_pv := 100
var degats = {"base": 1, "gros": 3, "feu": 6, "anti": 1000000000}
var DEBUG := true
var mouse_busy := false
var selected = null

#inventaire
var charbon := 0
var bois := 0
var pierre := 0
var brique := 50
var minerai_fer := 0
var lingot_fer := 0
var plaque_fer := 0
var cuivre := 0
var etain := 0
var bronze := 0
var engrenage_bronze := 0
var lingot_acier := 0
var barre_acier := 0
var minerai_gluantite := 0
var minerai_voidium := 0
var minerai_topaxium := 0
var lingot_gluantite := 0
var lingot_voidium := 0
var lingot_topaxium := 0

func _process(_delta) -> void:
	mouse_busy = selected != null


func _ready():
	if DEBUG:
		charbon = 1000
		bois = 1000
		pierre = 1000
		brique = 1000
		minerai_fer = 1000
		lingot_fer = 1000
		plaque_fer = 1000
		etain = 1000
		bronze = 1000
		engrenage_bronze = 1000
		lingot_acier = 1000
		barre_acier = 1000
		minerai_gluantite = 1000
		minerai_voidium = 1000
		minerai_topaxium = 1000
		lingot_gluantite = 1000
		lingot_voidium = 1000
		lingot_topaxium = 1000


func calcul_electrical_strength(bat_pos_x) -> int:
	if bat_pos_x > -400 and bat_pos_x < 400:
		return 0
	elif bat_pos_x > -900 and bat_pos_x < 900:
		return 1
	else:
		return 2


func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
