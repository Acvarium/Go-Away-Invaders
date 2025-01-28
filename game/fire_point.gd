extends Node2D
@export var fire_direction = -1
@export var speed_mult = 1.0
@onready var main_node = get_tree().get_root().get_node("Main")
@export var sound_effect_name = ""

func fire() -> Node2D:
	var new_bullet = main_node.spawn_effect("bullet", global_position, fire_direction)
	if new_bullet and is_instance_valid(new_bullet):
		new_bullet.speed = new_bullet.speed * speed_mult
		if has_node("Sound"):
			if $Sound.has_method("play_randomized"):
				$Sound.play_randomized()
			else:
				$Sound.play()
		if sound_effect_name != "":
			main_node.spawn_effect(sound_effect_name, global_position)
		return new_bullet
	return null
