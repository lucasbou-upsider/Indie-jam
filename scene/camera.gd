extends Camera2D

var shake_intensity := 0.0 #intensité du shake en cours
var active_shake_time := 0.0 #temps restant du shake en cours
var shake_decay := 5.0 #diminution du shake (en intensité/s)
var shake_time := 0.0 #temps depuis début du shake actuel (pour randomizer)
var shake_time_speed := 20.0 #mult de shake_time
var noise = FastNoiseLite.new()

func _physics_process(delta) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta

		offset = Vector2(noise.get_noise_2d(shake_time, 0) * shake_intensity, noise.get_noise_2d(0, shake_time) * shake_intensity)
		shake_intensity = max(shake_intensity - shake_decay*delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5*delta)

func screen_shake(intensity: int = 10, time: float = 1, decay: float = 5.0):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shake_decay = decay
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0
