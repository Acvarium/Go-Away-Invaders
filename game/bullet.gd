extends Area2D

var direction = -1
var speed = 500.0
var hit_count = 0

func set_mode(dir):
	direction = dir
	if dir > 0:
		random_shape()


func random_shape():
	$AnimationPlayer.play("shape" + str(randi_range(0, 2)))


func _physics_process(delta: float) -> void:
	position.y += speed * delta * direction


func _on_area_entered(area: Area2D) -> void:
	if hit_count < 1:
		if area.is_in_group("enemy") and direction < 0:
			area.hit()
		if area.is_in_group("bullet") and direction > 0:
			return
		if area.is_in_group("cover"):
			area.hit(direction)
	hit_count += 1
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if direction < 0:
		return
	if body.is_in_group("player"):
		body.hit()
	queue_free()
