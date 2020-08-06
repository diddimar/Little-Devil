extends Area2D

const speed = 900
var velocity = Vector2()
var direction = 1


func _physics_process(delta):
	velocity.x = speed * delta * direction
	velocity.y = (speed / 50 ) * -delta
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_GunShot_body_entered(body):
	queue_free()
