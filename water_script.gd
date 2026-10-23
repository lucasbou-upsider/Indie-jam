extends ColorRect
func _ready():
	# Au démarrage, déplace ce nœud à la toute dernière position de son parent
	# Cela garantit que tous les objets existants ou futurs enfants du parent sont au-dessus
	pass

func _process(_delta):
	if material is ShaderMaterial:
		material.set_shader_parameter("hauteur_eau_global", global_position.y)
	get_parent().move_child.call_deferred(self, -1)
	# OPTIONNEL : Si vous instanciez énormément d'objets en boucle, 
	# décommentez la ligne du dessous pour forcer l'eau à rester en dernier à chaque frame :
	# get_parent().move_child(self, -1)
