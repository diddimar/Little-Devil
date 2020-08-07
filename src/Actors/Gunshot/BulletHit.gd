extends AnimatedSprite

onready var rng = RandomNumberGenerator.new()
var hit_wall = true


func _ready():
	rotation = randomize_rotation() 
	if hit_wall:
		hit_obsticle()
	playing = true


func hit_obsticle():
	randomize_hit_pitch()
	$AudioStreamPlayer2D.stream = load("res://Assets/Sounds/Player/bullet_hit.wav")
	$AudioStreamPlayer2D.play()


func randomize_hit_pitch():
	randomize()
	var array = [0.96, 0.98, 1, 1.2, 1.4]
	var pitch = array[randi() % array.size()]
	$AudioStreamPlayer2D.pitch_scale = pitch

func randomize_rotation() -> int:
	rng.randomize()
	var random_rotation = rng.randf_range(0, 360)
	return random_rotation

func _on_BulletHit_animation_finished():
	queue_free()
