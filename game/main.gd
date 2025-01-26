extends Node2D
var bullet_prefab = preload("res://bullet.tscn")
var enemy_exp_prefab = preload("res://enemy_exp.tscn")
var current_score : int = 0
@export var score_label : Label


func restart_game():
	get_tree().reload_current_scene()


func get_player_position():
	return $Player.position


func spawn_effect(effect_name : String, pos : Vector2, mode_id = 0):
	var effect_instance
	if effect_name == "bullet":
		effect_instance = bullet_prefab.instantiate()
	elif effect_name == "enemy_exp":
		effect_instance = enemy_exp_prefab.instantiate()
	if effect_instance:
		$Effects.add_child(effect_instance)
		effect_instance.global_position = pos
		if effect_instance.has_method("set_mode"):
			effect_instance.set_mode(mode_id)
	return effect_instance


func add_score(score_value : int):
	current_score += score_value
	update_score_view()


func update_score_view():
	score_label.text = "%06d" % current_score


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
	elif event.is_action_pressed("restart"):
		restart_game()
