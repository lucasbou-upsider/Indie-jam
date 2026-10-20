extends Node

#pv
var base_pv := 100

var network = {}

var DEBUG := true

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

func calcul_electrical_strenght(bat_pos_x):
	if bat_pos_x > -400 and bat_pos_x < 400:
		return 0
	elif bat_pos_x > -900 and bat_pos_x < 900:
		return 1
	else:
		return 2



func _process(_delta) -> void:
	if Input.is_action_just_pressed("3"):
		print("connected:", are_connected(selected, selected2))
	if Input.is_action_just_pressed("5"):
		selected = null
		selected2 = null
	
	for node in network.keys():
		if not is_instance_valid(node):
			network.erase(node)


### electricité

var selected
var selected2

func is_powered(node) -> bool:
	var queue := []
	var explored := []
	var current
	for key in network[node].keys():
		queue.push_back(key)
		explored.push_back(key)
	while not queue == []:
		current = queue.pop_front()
		for n in network[current].keys():
			if n is Base:
				return true
			elif not n in explored:
				queue.push_back(n)
				explored.push_back(n)
	return false


func connect_buildings(b1, b2):
	network[b1][b2] = "ok"
	network[b2][b1] = "ok"
	b1.update_powered()
	b2.update_powered()

func are_connected(b1, b2) -> bool:
	print(network)
	return b1 in network[b2].keys() or b2 in network[b1].keys()

func disconnect_building(b1, b2):
	network[b1].erase(b2)
	network[b2].erase(b1)
	b1.update_powered()
	b2.update_powered()
