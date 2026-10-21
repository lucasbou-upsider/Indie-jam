extends RigidBody2D

@onready var despawn: Timer = $Despawn

@export var type := "base"
var physics_shape: CollisionShape2D
var despawn_area: Area2D


func defreeze():
	sleeping = false

func _ready() -> void:
	SIGNAL.connect("defreeze", defreeze)
	freeze = true
	var chute_aleatoire = randf_range(0, 2)
	await get_tree().create_timer(chute_aleatoire).timeout
	freeze = false

func set_type(new_type):
	type = new_type
	$KayouSprites.play(type)
	if type == "gros":
		$KayouSprites.scale = Vector2(0.55, 0.55)
		$PhysicsShapeGros.disabled = false
		$PhysicsShapePiti.disabled = true
		$DespawnAreaGros/AreaShape.disabled = false
		$DespawnAreaPiti/AreaShape.disabled = true
	else:
		$KayouSprites.scale = Vector2(0.275, 0.275)
		$PhysicsShapeGros.disabled = true
		$PhysicsShapePiti.disabled = false
		$DespawnAreaGros/AreaShape.disabled = true
		$DespawnAreaPiti/AreaShape.disabled = false

func _on_despawn_timeout() -> void:
	SIGNAL.emit_signal("defreeze")
	queue_free()


func _on_despawn_area_piti_body_entered(body: Node2D) -> void:
	if type != "gros":
		if not body.get_parent() is kayou_spawn:
			despawn.start()

func _on_despawn_area_gros_body_entered(body: Node2D) -> void:
	if type == "gros":
		if not body.get_parent() is kayou_spawn:
			despawn.start()
