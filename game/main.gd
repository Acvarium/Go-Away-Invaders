extends Node2D
var effects = {
	
"bullet" : preload("res://effects/bullet.tscn"),
"enemy_exp" : preload("res://effects/enemy_exp.tscn"),
"cover_exp_top" : preload("res://effects/cover_exp_top.tscn"),
"cover_exp_bottom" : preload("res://effects/cover_exp_bottom.tscn"),
"enemy_blaster_sound" : preload("res://effects/enemy_blaster_sound.tscn")
}

var current_score : int = 0
@export var score_label : Label


func restart_game():
	get_tree().reload_current_scene()


func get_player_position():
	return $Player.position


func spawn_effect(effect_name : String, pos : Vector2, mode_id = 0):
	var effect_instance
	if effect_name in effects.keys():
		effect_instance = effects[effect_name].instantiate()
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
		toggle_pause()
	elif event.is_action_pressed("restart"):
		restart_game()


func toggle_pause():
	pause_game(!get_tree().paused)


func pause_game(to_pause : bool = true):
	get_tree().paused = to_pause
