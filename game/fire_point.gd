extends Node2D
@export var fire_direction = -1
@export var speed_mult = 1.0
var bullet_prefab = preload("res://bullet.tscn")
@onready var main_node = get_tree().get_root().get_node("Main")


func fire() -> Node2D:
	var new_bullet = main_node.spawn_effect("bullet", global_position, fire_direction)
	if new_bullet and is_instance_valid(new_bullet):
		new_bullet.speed = new_bullet.speed * speed_mult
		return new_bullet
	return null
