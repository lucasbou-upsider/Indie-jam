extends Node

#pv
var base_pv := 100

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
		plaque_fer = 1000

func calcul_electrical_strength(bat_pos_x):
	if bat_pos_x > -400 and bat_pos_x < 400:
		return 0
	elif bat_pos_x > -900 and bat_pos_x < 900:
		return 1
	else:
		return 2
