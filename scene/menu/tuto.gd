extends Control

@onready var progress_bar: ProgressBar = $"../Interface/ProgressBar"
@onready var panel_construction: Panel = $"../Interface/Panel_construction"
@onready var coordoné: Label = $"../Interface/Coordoné"
@onready var panel_inventaire: Panel = $"../Interface/Panel_inventaire"
@onready var panel_vague: Panel = $"../Interface/Panel_vague"
@onready var rich_text_tuto_label: RichTextLabel = $CanvasLayer/Panel/RichTextTutoLabel
const BASE = preload("uid://byxo1qtpjx30p")
@onready var vague_timer: Timer = $"../Vague/vague_Timer"
@onready var panel_mur: Panel = $"../Interface/Panel_mur"


var phrases = [
	" welcome to [wave]FALLCTORY[/wave], a game about [u]base-building and defense[/u]",
	"here are [wave]the basics...[/wave]",
	"your [pulse][color=00ff00]goal[/color][/pulse] is to defend your base against 20 waves of [shake][color=d70000]incoming meteors[shake]",
	"in the [wave]top left[/wave] is the time left before the [color=d70000]next wave",
	"on the left you can see your [color=ffff00]resources and production...",
	"...and on the right [color=ff8500]the buildings",
	"every [color=ff8500]building[/color] is affected by [rainbow]physics[/rainbow], [fade]produces[/fade] some resources and may [fade] consume [/fade]others to do so",
	"some [color=ff8500]buildings[/color] have specific [shake]placement requirements",
	"horizontally, the closer the building is to [i]the center[/i], the [rainbow]faster[/rainbow] it works (3 tiers, signaled by color of coordinates in top-right)",
	"also, controls are: \n\n[u][color=8888dd]left click[/color][/u] to [color=22ff22]select/place[/color] buildings, \n[u][color=8888dd]right click[/color][/u] to [color=ff2222]delete[/color] (deletes on contact while held),",
	"and [u][color=8888dd]ZQSD[/color][/u] to move camera.\n\n[i][wave]You can also [color=8888dd]use arrows and SpaceBar[/color] to navigate the menus![/wave][/i]",
	"overall, the game is divided into [wave]4 main phases[/wave] of 5 waves, each with new [color=d70000]dangers[/color] and [color=ff8500]buildings",
	"[rainbow]Have fun!"
]

var numero_phrase = 0
func _ready() -> void:
	panel_mur.visible = false
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
	if event.is_action_pressed("click droit") or event.is_action_pressed("click gauche") and GLOBAL.is_paused == false:
		numero_phrase += 1
		if numero_phrase == 2:
			progress_bar.visible = true
		elif numero_phrase == 3:
			panel_vague.visible = true
		elif numero_phrase == 4:
			panel_inventaire.visible = true
		elif numero_phrase == 5:
			panel_construction.visible = true
			panel_mur.visible = true
		if numero_phrase == 8:
			coordoné.visible = true
		elif numero_phrase == phrases.size():
			vague_timer.start()
			get_parent().add_child(BASE.instantiate())
			get_parent().tuto_over = true
			queue_free()
