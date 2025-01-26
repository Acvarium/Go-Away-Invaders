extends Node2D
var explosion_force = 100000.0


func _ready() -> void:
	$CPUParticles2D.one_shot = true
	$CPUParticles2D.emitting = true
	#await get_tree().physics_frame
	await get_tree().physics_frame
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.explosion(position, explosion_force)


func set_mode(mode_id : int):
	$Sprite2D.frame = mode_id * 3 + 2
