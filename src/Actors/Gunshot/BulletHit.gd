extends AnimatedSprite

onready var rng = RandomNumberGenerator.new()

func randomize_hit_pitch():
	randomize()
	var array = [0.96, 0.98, 1, 1.2, 1.4]
	var pitch = array[randi() % array.size()]
	$AudioStreamPlayer2D.pitch_scale = pitch

func randomize_rotation() -> int:
	rng.randomize()
	var random_rotation = rng.randf_range(0, 360)
	return random_rotation

func _ready():
	rotation = randomize_rotation() 
	randomize_hit_pitch()
	playing = true

func _on_BulletHit_animation_finished():
	queue_free()
