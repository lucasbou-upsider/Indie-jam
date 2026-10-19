extends RigidBody2D

@onready var despawn: Timer = $Despawn

func _ready() -> void:
	freeze = true
	var chute_aleatoire = randf_range(0, 2)
	await get_tree().create_timer(chute_aleatoire).timeout 
	freeze = false


func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().name != "kayou_spawn":
		despawn.start()


func _on_despawn_timeout() -> void:
	queue_free()
