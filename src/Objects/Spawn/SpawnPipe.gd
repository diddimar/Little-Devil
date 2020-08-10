extends StaticBody2D


var fly_scene = preload("res://src/Actors/Enemies/Fly/Fly.tscn")
var spawning_started = false
export var number_of_flies = 10
export var spawning_interval = 1.0


func start_spawning():
	var i = 0
	while i < number_of_flies and spawning_started:
		number_of_flies -= 1
		spawn_fly()
		yield(get_tree().create_timer(spawning_interval),"timeout")
	
	$AnimationPlayer.play("finished")


func spawn_fly():
	var new_fly = fly_scene.instance()
	new_fly.position = position
	new_fly.position.y += 50
	get_parent().add_child(new_fly)
	$AnimationPlayer.play("spawn")
	


func _on_VisibilityNotifier2D_screen_entered():
	if not spawning_started:
		$AnimationPlayer.play("starting")


func _on_VisibilityNotifier2D_screen_exited():
	if spawning_started:
		spawning_started = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "starting"):
		spawning_started = true
		start_spawning()
	elif(anim_name == "finished"):
		queue_free()
