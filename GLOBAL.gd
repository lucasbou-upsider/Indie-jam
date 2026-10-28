extends Node

#pv
var tool_tip: RichTextLabel
var base_pv := 100
var degats = {"base": 1, "gros": 3, "feu": 6, "anti": 1000000000}
var DEBUG := false
var mouse_busy := false
var selected = null
var is_paused = false
var is_building = false
var in_destroy_mod = false

#inventaire
var time_left: float
var vague_number: int
var charbon := 0
var bois := 100
var pierre := 0
var brique := 300
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
	if Input.is_action_just_pressed("save"):
		save_game()
	elif Input.is_action_just_pressed("load"):
		load_game()


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
			if node.has_method("save"):
				save_file.store_line(JSON.stringify(node.save()))
			else:
				print("persistent node '%s' is not an instanced scene, skipped" % node.name)
				continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)

	var global_save = {
	"filename": "global_save",
	"selected": selected,
	"base_pv": base_pv,
	"charbon": charbon,
	"bois": bois,
	"pierre": pierre,
	"brique": brique,
	"minerai_fer": minerai_fer,
	"lingot_fer": lingot_fer,
	"plaque_fer": plaque_fer,
	"etain": etain,
	"bronze": bronze,
	"engrenage_bronze": engrenage_bronze,
	"lingot_acier": lingot_acier,
	"barre_acier": barre_acier,
	"minerai_gluantite": minerai_gluantite,
	"minerai_voidium": minerai_voidium,
	"minerai_topaxium": minerai_topaxium,
	"lingot_gluantite": lingot_gluantite,
	"lingot_voidium": lingot_voidium,
	"lingot_topaxium": lingot_topaxium
	}
	save_file.store_line(JSON.stringify(global_save))

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return #no save found

	#reset state of game
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for i in save_nodes:
		if not i.scene_file_path.is_empty():
			i.queue_free()


	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.data
		if node_data["filename"] != "global_save" and node_data["filename"] != "vague":
			var new_object = load(node_data["filename"]).instantiate()
			get_node(node_data["parent"]).add_child(new_object)
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, node_data[i])
			new_object.modulate = Color(1, 1, 1, 1)
			if !new_object is kayou:
				new_object.place_self()
			new_object.collision_polygon_2d.disabled = false
		elif node_data["filename"] == "global_save":
			for i in node_data.keys():
				if i != "filename":
					set(i, node_data[i])
		elif node_data["filename"] == "vague":
			$"../world/Vague".vague_number = node_data["vague_number"]
			$"../world/Vague".vague_timer.wait_time = node_data["time_left"]
			$"../world/Vague".vague_timer.stop()
			$"../world/Vague".vague_timer.start()
