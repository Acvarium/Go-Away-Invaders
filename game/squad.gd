extends Node2D
var move_direction = Vector2.RIGHT
var to_go_down = false
var step_size = 4.0
var down_step_size = 22.0
var entities = []
var current_entity_id = 0
var next_step_wall_dist : float = INF
var squad_duration = 1.0
var movements = []
@onready var ticks_per_sec = Engine.physics_ticks_per_second
const MIN_SQUAD_DURATION = 1.0/55.0
const ENEMIES_GRID_AMOUNT : Vector2i = Vector2i(11, 5)
var row_skins = [2, 2, 1, 1, 0]
var enemy_prefab = preload("res://enemy.tscn")
const MIN_FIRE_TIME = 0.8
const MAX_FIRE_TIME = 3.0
@onready var main_node = get_tree().get_root().get_node("Main")
var start_enemies_count = 55
var movement_pause_frames : int = 0


func update_enemies_speed():
	var enemies_count = $Entities.get_child_count()
	var new_move_duration = remap(enemies_count, 1, start_enemies_count, 
		0.4, 1.0)
	change_squad_move_duration(new_move_duration)


func pause_movement(frames : int):
	movement_pause_frames = frames
	

func build_entity_array():
	for entity : Area2D in $Entities.get_children():
		entities.append(weakref(entity))


func spawn_enemy(pos : Vector2, skin : int = 0):
	var new_enemy = enemy_prefab.instantiate()
	$Entities.add_child(new_enemy, true)
	new_enemy.set_direct_position(pos)
	new_enemy.skin = skin


func explosion(pos):
	print(Engine.get_physics_frames())

	for enemy in $Entities.get_children():
		print(enemy.name)
		

func generate_enemies():
	var start_pos = $EnemyPos.position
	var x_step = abs(start_pos.x - $EnemyXOffset.position.x)
	var y_step = abs(start_pos.y - $EnemyYOffset.position.y)
	
	var new_pos = start_pos
	for y in range(ENEMIES_GRID_AMOUNT.y):
		new_pos.x = start_pos.x
		for x in range(ENEMIES_GRID_AMOUNT.x):
			spawn_enemy(new_pos, row_skins[y])
			new_pos.x += x_step
		new_pos.y -= y_step
	start_enemies_count = $Entities.get_child_count()


func change_squad_move_duration(new_duration : float):
	squad_duration = new_duration
	if squad_duration < MIN_SQUAD_DURATION:
		squad_duration = MIN_SQUAD_DURATION
	calculate_movement()


func _ready() -> void:
	generate_enemies()
	build_entity_array()
	calculate_movement()


func calculate_movement():
	var current_frame = Engine.get_physics_frames()
	var total_frames = ticks_per_sec * squad_duration
	var avg_entity_per_frame = float(entities.size()) / total_frames
	var accumulator = 0.0
	movements = []
	for frames in range(int(total_frames)):
		accumulator += avg_entity_per_frame
		var move_count = int(accumulator)
		movements.append(move_count)
		accumulator -= move_count


func make_step(delta : float):
	if movement_pause_frames > 0:
		movement_pause_frames -= 1
		return
	var current_frame = Engine.get_physics_frames()
	var selected_move_id = current_frame % movements.size()
	var entities_to_move = movements[selected_move_id]
	
	var moved_entity = 0
	while moved_entity < entities_to_move:
		while current_entity_id < entities.size() and not entities[current_entity_id].get_ref():
			current_entity_id += 1
		if current_entity_id >= entities.size():
			if to_go_down:
				to_go_down = false
			current_entity_id = 0
			if next_step_wall_dist < step_size:
				switch_direction()
			next_step_wall_dist = INF
			return
		var current_entity : Area2D = entities[current_entity_id].get_ref()
		var current_move = move_direction * step_size
		if to_go_down:
			current_move += Vector2(0, down_step_size)
			
		var current_wall_dist = current_entity.make_step(current_move)
		if current_wall_dist < next_step_wall_dist:
			next_step_wall_dist = current_wall_dist
		current_entity_id += 1
		moved_entity += 1


func switch_direction():
	to_go_down = true
	move_direction.x = -move_direction.x


func _physics_process(delta: float) -> void:
	make_step(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("speed_up"):
		change_squad_move_duration(squad_duration - 0.1)
	if event.is_action_pressed("speed_down"):
		change_squad_move_duration(squad_duration + 0.1)


func get_list_of_lowest():
	var lowest_enemies = []
	for enemy in entities:
		if enemy and enemy.get_ref():
			if enemy.get_ref().is_lowest():
				lowest_enemies.append(enemy.get_ref())
	return lowest_enemies


func get_x_dist_to_player(pos : Vector2) -> float:
	var dist = abs(pos.x - main_node.get_player_position().x)
	return dist


func get_closest_enemy(enemy_list : Array) -> int:
	var closest_id = 0
	if enemy_list.size() == 1:
		return 0
	var current_x_dist = get_x_dist_to_player(enemy_list[0].position)
	for i in range(1, enemy_list.size()):
		var next_x_dist = get_x_dist_to_player(enemy_list[i].position)
		if next_x_dist < current_x_dist:
			current_x_dist = next_x_dist
			closest_id = i
	return closest_id


func enemy_fire():
	var list_of_lowest = get_list_of_lowest()
	var closest_enemy_id = get_closest_enemy(list_of_lowest)
	var fire_enemy_id = closest_enemy_id
	if randf() > 0.5:
		fire_enemy_id = randi_range(0, list_of_lowest.size() - 1)
	list_of_lowest[fire_enemy_id].fire()


func _on_fire_timer_timeout() -> void:
	if $Entities.get_child_count() == 0:
		return
	$FireTimer.wait_time = remap(randf(), 0, 1, MIN_FIRE_TIME, MAX_FIRE_TIME)
	$FireTimer.start()
	enemy_fire()
