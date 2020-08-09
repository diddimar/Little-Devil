extends Area2D

const speed = 900
var velocity = Vector2()
var direction = 1

var bullet_hit = preload("res://src/Actors/Gunshot/BulletHit.tscn")
#var fly_hit = preload("res://src/Actors/Enemies/Fly/FlyBloodSplatter.tscn")


func _physics_process(delta):
	velocity.x = speed * delta * direction
	velocity.y = (speed / 50 ) * -delta
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_GunShot_body_entered(body):
	var bullet_hit_instance = bullet_hit.instance()
	bullet_hit_instance.position = get_global_position()
	

	if("Fly" in body.name):
		bullet_hit_instance.wall_hit = false
		bullet_hit_instance.self_modulate = Color(1,0,0)
		body.kill()
		var fly_hit_instance = load("res://src/Actors/Enemies/Fly/FlyBloodSplatter.tscn").instance()
		fly_hit_instance.position = get_global_position()
		if(direction > 0):
			fly_hit_instance.flip_h = true
			fly_hit_instance.position.x += 20
		else:
			fly_hit_instance.position.x -= 15
			
		get_tree().get_root().add_child(fly_hit_instance)

	get_tree().get_root().add_child(bullet_hit_instance)
	

	queue_free()
