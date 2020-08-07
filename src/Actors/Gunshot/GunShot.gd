extends Area2D

const speed = 900
var velocity = Vector2()
var direction = 1

var bullet_hit = preload("res://src/Actors/Gunshot/BulletHit.tscn")

func _physics_process(delta):
	velocity.x = speed * delta * direction
	velocity.y = (speed / 50 ) * -delta
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_GunShot_body_entered(body):
	var bullet_hit_instance = bullet_hit.instance()
	bullet_hit_instance.position = get_global_position()
	if(body.name.begins_with("Fly")):
		body.kill()
		bullet_hit_instance.hit_wall = false
	else:
		bullet_hit_instance.hit_wall = true

	get_tree().get_root().add_child(bullet_hit_instance)
	queue_free()
