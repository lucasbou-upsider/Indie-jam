extends Control
@onready var death: CanvasLayer = $death
@onready var victory: CanvasLayer = $victory

func _process(_delta: float) -> void:
	if GLOBAL.base_pv <= 0:
		Engine.time_scale = 0
		death.visible = true
