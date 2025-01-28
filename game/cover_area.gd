extends Area2D
@export var max_hits = 3
var hits = 0
@export var upper_block : Area2D
@export var lower_block : Area2D
@onready var main_node = get_tree().get_root().get_node("Main")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_frame(dir):
	var h_frames = $CoverSprite.hframes
	var v_frames = $CoverSprite.vframes
	var next_frame = $CoverSprite.frame 
	if dir > 0:
		next_frame += 1
	else:
		next_frame += h_frames
	if next_frame < h_frames * v_frames:
		$CoverSprite.frame = next_frame

func destroy():
	queue_free()


func spawn_exp_effect(dir):
	if dir > 0:
		main_node.spawn_effect("cover_exp_top", global_position)
	else:
		main_node.spawn_effect("cover_exp_bottom", global_position)
		

func hit(dir):
	hits += 1
	if hits >= max_hits:
		var hit_neighbor = false
		if dir > 0 and lower_block and is_instance_valid(lower_block):
			lower_block.hit(dir)
			hit_neighbor = true
		elif dir < 0 and upper_block and is_instance_valid(upper_block):
			upper_block.hit(dir)
			hit_neighbor = true
		if !hit_neighbor:
			spawn_exp_effect(dir)
		queue_free()
	else:
		update_frame(dir)
		spawn_exp_effect(dir)
