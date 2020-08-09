extends AnimatedSprite

onready var rng = RandomNumberGenerator.new()


func _ready():
	randomize_hit_pitch()

func randomize_hit_pitch():
	randomize()
	var array = [0.96, 0.98, 1, 1.2, 1.4]
	var pitch = array[randi() % array.size()]
	$AudioStreamPlayer2D.pitch_scale = pitch

func _on_FlyBloodSplatter_animation_finished():
	queue_free()
