@tool
extends Area2D
const SKINS = 3
const ANIM_FRAMES = 3
var current_frame = 0
@onready var next_position : Vector2 = position
@onready var squad = get_node("../..")
@export var debug_entity = false
@export var to_die = false
@onready var main_node
const MIN_SPEED = 5.0
const MAX_SPEED = 20.0
const MIN_X_POS = 24
const MAX_X_POS = 605
const SCORES = [30, 20, 10]
var exp_offset : Vector2 = Vector2()
var exp_move_speed = 1.0

@export var skin : int = 0 :
	set(value):
		if value >= SKINS:
			value = 0
		elif value < 0:
			value = SKINS - 1
		skin = value
		update_sprite()


func explosion(exp_pos : Vector2, exp_force : float):
	exp_move_speed = 5.0
	var exp_direction = exp_pos.direction_to(position).normalized()
	var exp_dist = exp_pos.distance_to(position)
	exp_force /= exp_dist * exp_dist
	add_exp_offset(exp_direction * exp_force)


func hit():
	main_node.spawn_effect("enemy_exp", global_position, skin)
	squad.update_enemies_speed()
	squad.pause_movement(30)
	main_node.add_score(SCORES[skin])
	queue_free()


func set_direct_position(pos):
	next_position = pos
	position = pos


func _ready() -> void:
	update_sprite()
	if(Engine.is_editor_hint()):
		return
	main_node = get_tree().get_root().get_node("Main")


func update_sprite():
	$Sprite2D.frame = skin * ANIM_FRAMES + current_frame
	$Shadow.frame = skin * ANIM_FRAMES + current_frame
	$S1.disabled = skin != 0
	
	$S2.disabled = skin != 1
	$S3.disabled = skin != 2


func add_exp_offset(new_exp_offset : Vector2):
	exp_offset += new_exp_offset


func _physics_process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		return
	exp_offset = lerp(exp_offset, Vector2(), delta * 10.0)

	var movement_speed = remap(squad.squad_duration, squad.MIN_SQUAD_DURATION, 1.0, 20.0, 5.0)
	movement_speed = clamp(movement_speed, MIN_SPEED, MAX_SPEED)
	position = lerp(position, next_position + exp_offset, delta * movement_speed * exp_move_speed)
	if position.y > 550:
		main_node.restart_game()
	exp_move_speed = lerp(exp_move_speed, 1.0, delta * 20.0)
	
func _process(delta: float) -> void:
	if(Engine.is_editor_hint()):
		return
	if to_die:
		hit()


func make_step(direction : Vector2) -> float:
	var coll_dist : float = INF
	next_position += direction
	
	if direction.x > 0:
		coll_dist = MAX_X_POS - next_position.x
	else:
		coll_dist = next_position.x - MIN_X_POS
	if debug_entity:
		print(direction.x, " : ", coll_dist)
	current_frame += 1
	if current_frame >= 2:
		current_frame = 0
		
	update_sprite()
	return coll_dist


func fire():
	$FirePoint.fire()


func show_debug_text(text):
	$Label.text = name


func is_lowest() -> bool:
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("enemy"):
		#$Label.text = ""
		return false
	#$Label.text = "**" + name
	return true
