extends Node2D

const base = preload("uid://byxo1qtpjx30p")
@onready var progress_bar: ProgressBar = $Interface/ProgressBar


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	progress_bar.value = GLOBAL.base_pv




func _on_button_base_pressed() -> void:
	add_child(base.instantiate())
