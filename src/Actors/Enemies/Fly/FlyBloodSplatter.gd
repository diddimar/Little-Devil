extends AnimatedSprite


func _ready():
	pass


func _on_FlyBloodSplatter_animation_finished():
	queue_free()
