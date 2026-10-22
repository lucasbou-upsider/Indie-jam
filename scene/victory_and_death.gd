extends Control
@onready var death: CanvasLayer = $death
@onready var victory: CanvasLayer = $victory
@onready var interface: CanvasLayer = $"../Interface"
@onready var vague: Node2D = $"../Vague"

func _process(_delta: float) -> void:
	if GLOBAL.base_pv <= 0 and victory.visible == false:
		death.visible = true
		interface.visible = false

	if vague.vague_number == 19 and death.visible == false:
		await get_tree().create_timer(15).timeout
		victory.visible = true
		interface.visible = false




func reset():
	GLOBAL.base_pv = 100
	GLOBAL.mouse_busy = false
	GLOBAL.selected = null
	GLOBAL.is_paused = false
	GLOBAL.charbon = 0
	GLOBAL.bois = 0
	GLOBAL.pierre = 0
	GLOBAL.brique = 50
	GLOBAL.minerai_fer = 0
	GLOBAL.lingot_fer = 0
	GLOBAL.plaque_fer = 0
	GLOBAL.cuivre = 0
	GLOBAL.etain = 0
	GLOBAL.bronze = 0
	GLOBAL.engrenage_bronze = 0
	GLOBAL.lingot_acier = 0
	GLOBAL.barre_acier = 0
	GLOBAL.minerai_gluantite = 0
	GLOBAL.minerai_voidium = 0
	GLOBAL.minerai_topaxium = 0
	GLOBAL.lingot_gluantite = 0
	GLOBAL.lingot_voidium = 0
	GLOBAL.lingot_topaxium = 0


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")
	reset()
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/title_screen.tscn")
	reset()
func _on_quit_pressed() -> void:
	get_tree().quit()
