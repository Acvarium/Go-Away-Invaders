extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize) 
	resize()
	

func resize():
	var viewport_width = ProjectSettings.get("display/window/size/viewport_width")
	var viewport_heigth = ProjectSettings.get("display/window/size/viewport_height")
	var original_aspect = float(viewport_width) / float(viewport_heigth)
	var current_aspect = float(get_viewport().size.x) / float(get_viewport().size.y)
	if current_aspect > original_aspect:
		var game_x_size = viewport_heigth * current_aspect
		position.x = -float(game_x_size - viewport_width) / 2
	else:
		position.x = 0
