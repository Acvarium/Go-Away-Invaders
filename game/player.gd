extends CharacterBody2D
@onready var main_node = get_tree().get_root().get_node("Main")
const SPEED = 300.0
var current_bullet : WeakRef

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		if not current_bullet or not current_bullet.get_ref():
			fire()


func fire():
	var new_bullet = $FirePoint.fire()
	if new_bullet:
		current_bullet = weakref(new_bullet)


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func hit():
	$AnimationPlayer.play("hit")
	await get_tree().physics_frame
	await get_tree().physics_frame
	main_node.pause_game()
