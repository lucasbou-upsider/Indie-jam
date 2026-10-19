extends Panel

@onready var charbon: RichTextLabel = $VBoxContainer/charbon
@onready var bois: RichTextLabel = $VBoxContainer/bois
@onready var pierre: RichTextLabel = $VBoxContainer/pierre
@onready var brique: RichTextLabel = $VBoxContainer/brique
@onready var minerai_fer: RichTextLabel = $VBoxContainer/minerai_fer
@onready var lingot_fer: RichTextLabel = $VBoxContainer/lingot_fer
@onready var plaque_fer: RichTextLabel = $VBoxContainer/plaque_fer
@onready var cuivre: RichTextLabel = $VBoxContainer/cuivre
@onready var etain: RichTextLabel = $VBoxContainer/etain
@onready var bronze: RichTextLabel = $VBoxContainer/bronze
@onready var engrenage_bronze: RichTextLabel = $VBoxContainer/engrenage_bronze
@onready var lingot_acier: RichTextLabel = $VBoxContainer/lingot_acier
@onready var barre_acier: RichTextLabel = $VBoxContainer/barre_acier
@onready var minerai_gluantite: RichTextLabel = $VBoxContainer/minerai_gluantite
@onready var lingot_gluantite: RichTextLabel = $VBoxContainer/lingot_gluantite
@onready var minerai_topaxium: RichTextLabel = $VBoxContainer/minerai_topaxium
@onready var lingot_topaxium: RichTextLabel = $VBoxContainer/lingot_topaxium
@onready var minerai_voidium: RichTextLabel = $VBoxContainer/minerai_voidium
@onready var lingot_voidium: RichTextLabel = $VBoxContainer/lingot_voidium

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	charbon.text = "      " + str(GLOBAL.charbon)
	bois.text = "      " + str(GLOBAL.bois)
	pierre.text = "      " + str(GLOBAL.pierre)
	brique.text = "      " + str(GLOBAL.brique)
	minerai_fer.text = "      " + str(GLOBAL.minerai_fer)
	lingot_fer.text = "      " + str(GLOBAL.lingot_fer)
	plaque_fer.text = "      " + str(GLOBAL.plaque_fer)
	cuivre.text = "      " + str(GLOBAL.cuivre)
	etain.text = "      " + str(GLOBAL.etain)
	bronze.text = "      " + str(GLOBAL.bronze)
	engrenage_bronze.text = "      " + str(GLOBAL.engrenage_bronze)
	lingot_acier.text = "      " + str(GLOBAL.lingot_acier)
	barre_acier.text = "      " + str(GLOBAL.barre_acier)
	minerai_gluantite.text = "      " + str(GLOBAL.minerai_gluantite)
	lingot_gluantite.text = "      " + str(GLOBAL.lingot_gluantite)
	minerai_topaxium.text = "      " + str(GLOBAL.minerai_topaxium)
	lingot_topaxium.text = "      " + str(GLOBAL.lingot_topaxium)
	minerai_voidium.text = "      " + str(GLOBAL.minerai_voidium)
	lingot_voidium.text = "      " + str(GLOBAL.lingot_voidium)
