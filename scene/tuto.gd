extends Control

@onready var progress_bar: ProgressBar = $"../Interface/ProgressBar"
@onready var panel_construction: Panel = $"../Interface/Panel_construction"
@onready var coordoné: Label = $"../Interface/Coordoné"
@onready var panel_inventaire: Panel = $"../Interface/Panel_inventaire"
@onready var panel_vague: Panel = $"../Interface/Panel_vague"
@onready var rich_text_tuto_label: RichTextLabel = $CanvasLayer/Panel/RichTextTutoLabel
const BASE = preload("uid://byxo1qtpjx30p")


var phrases = [
	"welcome to MAMADOU, a game about base-building and defense",
	"here are the basics...",
	"your goal is to defend your base against 20 waves of incoming meteors",
	"in the top left is the time left before the next wave",
	"on the left you can see your resources and production...",
	"...and on the right the buildings",
	"every building is affected by physics, produces some resources and may consume others to do so",
	"some buildings have specific placement requirements",
	"horizontally, the closer the building is to the center, the faster it works",
	"the game is divided into 4 main phases, each with new dangers and buildings",
	"Have fun!"
]

var numero_phrase = 0
func _ready() -> void:
	progress_bar.visible = false
	panel_construction.visible = false
	coordoné.visible = false
	panel_inventaire.visible = false
	panel_vague.visible = false
	rich_text_tuto_label.text = phrases[0]


func _process(_delta: float) -> void:
	if numero_phrase < phrases.size():
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
