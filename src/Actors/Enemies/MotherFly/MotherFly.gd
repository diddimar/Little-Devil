extends KinematicBody2D

var fly_scene = preload("res://src/Actors/Enemies/Fly/Fly.tscn")
var spawning_started = false
export var number_of_flies = 10
export var spawning_interval = 1


func _ready():
	pass


func _process(delta):
	pass


func start_spawning():
	var i = 0
	while i < number_of_flies:
		number_of_flies -= 1
		spawn_fly()
		yield(get_tree().create_timer(spawning_interval),"timeout")




func spawn_fly():
	var new_fly = fly_scene.instance()
	new_fly.position = position
	get_parent().add_child(new_fly)


func _on_VisibilityNotifier2D_screen_entered():
	if not spawning_started:
		spawning_started = true
		start_spawning()
