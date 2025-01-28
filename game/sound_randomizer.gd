extends AudioStreamPlayer2D
@export var play_on_start = false
@export var pitch_scale_min = 0.9
@export var pitch_scale_max = 1.1


func _ready() -> void:
	if play_on_start:
		play_randomized()


func play_randomized():
	pitch_scale = remap(randf(), 0, 1, pitch_scale_min, pitch_scale_max)
	play()
