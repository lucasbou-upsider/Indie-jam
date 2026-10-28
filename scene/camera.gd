extends Camera2D

var shake_intensity := 0.0 #intensité du shake en cours
var active_shake_time := 0.0 #temps restant du shake en cours
var shake_decay := 5.0 #diminution du shake (en intensité/s)
var shake_time := 0.0 #temps depuis début du shake actuel (pour randomizer)
var shake_time_speed := 20.0 #mult de shake_time
var noise = FastNoiseLite.new()

# --- OPTIONS DU ZOOM ---
@export var min_zoom := 0.5
@export var max_zoom := 2.0
@export var zoom_speed := 0.05

var touch_events := {}
var last_touch_dist := 0.0
# ------------------------

# Variable pour suivre si l'utilisateur est en train de glisser
var is_dragging: bool = false

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

func _unhandled_input(event: InputEvent) -> void:
	if GLOBAL.is_building == false:
		# --- GESTION DU ZOOM MOUSE (Pour tester sur PC) ---
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				is_dragging = event.pressed
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				set_zoom_level(zoom.x + zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				set_zoom_level(zoom.x - zoom_speed)
				
		# --- GESTION DU PINCH-TO-ZOOM ET DES TOUCHES MOBILE ---
		if event is InputEventScreenTouch:
			if event.pressed:
				touch_events[event.index] = event.position
			else:
				touch_events.erase(event.index)
				if touch_events.size() < 2:
					last_touch_dist = 0.0
					
			# On n'autorise le drag que si un seul doigt touche l'écran
			if touch_events.size() == 1:
				is_dragging = true
			else:
				is_dragging = false

		if event is InputEventScreenDrag:
			touch_events[event.index] = event.position
			
			# SI 1 SEUL DOIGT : Déplacement fluide et proportionnel au zoom
			if touch_events.size() == 1 and is_dragging:
				position -= event.relative / zoom.x
				clamp_position_to_limits() # <-- Bloque la position immédiatement aux limites
			
			# SI 2 DOIGTS : On gère uniquement le pinch-to-zoom
			elif touch_events.size() == 2:
				is_dragging = false 
				var keys = touch_events.keys()
				var current_dist = touch_events[keys[0]].distance_to(touch_events[keys[1]])
				
				if last_touch_dist > 0.0:
					var zoom_factor = current_dist / last_touch_dist
					set_zoom_level(zoom.x * zoom_factor)
					
				last_touch_dist = current_dist

		# Déplacement classique à la souris (PC) - proportionnel au zoom
		if event is InputEventMouseMotion and is_dragging and touch_events.size() == 0:
			position -= event.relative / zoom.x
			clamp_position_to_limits() # <-- Bloque la position immédiatement aux limites

# Fonction utilitaire pour appliquer le zoom et respecter les limites
func set_zoom_level(new_zoom: float) -> void:
	var clamped_zoom = clamp(new_zoom, min_zoom, max_zoom)
	zoom = Vector2(clamped_zoom, clamped_zoom)
	# Le changement de zoom peut déplacer les bordures visibles, on re-clamp
	clamp_position_to_limits()

# NOUVELLE FONCTION : Empêche la position réelle de dépasser les limites de la caméra
func clamp_position_to_limits() -> void:
	# Calcule la taille de la zone visible à l'écran en fonction du zoom
	var screen_size = get_viewport_rect().size / zoom
	var half_screen = screen_size / 2.0
	
	# Calcule les positions minimales et maximales autorisées pour le centre de la caméra
	var min_x = limit_left + half_screen.x
	var max_x = limit_right - half_screen.x
	var min_y = limit_top + half_screen.y
	var max_y = limit_bottom - half_screen.y
	
	# Sécurité si les limites sont plus petites que l'écran (évite les inversions)
	if min_x > max_x: min_x = (limit_left + limit_right) / 2.0; max_x = min_x
	if min_y > max_y: min_y = (limit_top + limit_bottom) / 2.0; max_y = min_y

	# Bloque strictement la position
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
