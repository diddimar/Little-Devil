extends Area2D

const speed = 900
var velocity = Vector2()
var direction = 1

var bullet_hit = preload("res://src/Actors/Gunshot/BulletHit.tscn")
var fly_hit = preload("res://src/Actors/Enemies/Fly/FlyBloodSplatter.tscn")

func _physics_process(delta):
	velocity.x = speed * delta * direction
	velocity.y = (speed / 50 ) * -delta
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_GunShot_body_entered(body):
	if(body.name.begins_with("Fly")):
		body.kill()
		var fly_hit_instance = fly_hit.instance()
		fly_hit_instance.position = get_global_position()
		if(direction > 0):
			fly_hit_instance.flip_h = true
			fly_hit_instance.position.x += 20
		else:
			fly_hit_instance.position.x -= 15
			
		get_tree().get_root().add_child(fly_hit_instance)

	else:
		var bullet_hit_instance = bullet_hit.instance()
		bullet_hit_instance.position = get_global_position()
		get_tree().get_root().add_child(bullet_hit_instance)

	queue_free()
