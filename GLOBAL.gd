extends Node

#pv
var base_pv := 100

var network = {}

var DEBUG := true

var is_useless := true

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

func _ready():
	if DEBUG:
		charbon = 1000
		bois = 1000
		pierre = 1000
		brique = 1000
		minerai_fer = 1000
		lingot_fer = 1000

func is_powered(node, explored = []) -> bool:
	var new_explored = duplicate(explored)
	new_explored.append_array(network[node])
	if node.name == "Base":
		return true
	else:
		var result := false
		for i in range(len(network[node])):
			result = result or is_powered(network[node][i], new_explored)
		return result

func connect_buildings(b1, b2):
	network[b1][b2] = ""
	network[b2][b1] = ""

func disconnect_building(b1, b2):
	network[b1].del(b2)
	network[b2].del(b1)
