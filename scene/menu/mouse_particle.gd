extends Node2D

@onready var mouse_cpu_particles_2d: CPUParticles2D = $mouseCPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_cpu_particles_2d.global_position = get_global_mouse_position()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click gauche"):
		mouse_cpu_particles_2d.emitting = true
