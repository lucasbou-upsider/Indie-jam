extends Control

@onready var progress_bar: ProgressBar = $"../Interface/ProgressBar"
@onready var panel_construction: Panel = $"../Interface/Panel_construction"
@onready var coordoné: Label = $"../Interface/Coordoné"
@onready var panel_inventaire: Panel = $"../Interface/Panel_inventaire"
@onready var panel_vague: Panel = $"../Interface/Panel_vague"
@onready var rich_text_tuto_label: RichTextLabel = $CanvasLayer/Panel/RichTextTutoLabel
const BASE = preload("uid://byxo1qtpjx30p")


var phrases = [
	"bienvenu dans MAMADOU, un jeu de gestion de batiments et de defence",
	"voici les bases du jeu...",
	"votre objectif est de defendre votre base contre 20 vagues de meteorites",
	"en haut a gauche se trouve le temps avant la prochaine vague",
	"a gauche vous pouvez voir votre prodution",
	"et a droite vos batiments",
	"chaque batimens est affecté par la physique et coute des minerais pour etre construit, et en echange en produit d'autre",
	"placez les bien car certain batiments on des specificités de placement pour fonctionner",
	"plus le batiments est proche du centre, plus il est performant",
	"pour finir, le jeu est divisé en 4 phases augmentant chacun la difficulté des meteorites mais aussi debloquant de nouveau craft",
	"bonne chance !"
]

var numero_phrase = 0
func _ready() -> void:
	progress_bar.visible = false
	panel_construction.visible = false
	coordoné.visible = false
	panel_inventaire.visible = false
	panel_vague.visible = false
	rich_text_tuto_label.text = phrases[0]


func _process(delta: float) -> void:
	if numero_phrase < 11:
		rich_text_tuto_label.text = phrases[numero_phrase]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click droit") or event.is_action_pressed("click gauche"):
		numero_phrase += 1
		if numero_phrase == 2:
			progress_bar.visible = true
		if numero_phrase == 3:
			panel_vague.visible = true
		if numero_phrase == 4:
			panel_inventaire.visible = true
		if numero_phrase == 5:
			panel_construction.visible = true
		if numero_phrase == 11:
			queue_free()
			get_parent().add_child(BASE.instantiate())
		
		
		
		
