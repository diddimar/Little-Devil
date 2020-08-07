extends KinematicBody2D


onready var Player = get_parent().get_parent().get_node("Player")

var dead = false
var vel = Vector2(0, 0)

var grav = 800
var max_grav = 2000

var react_time = 400
var dir = 0
var next_dir = 0
var next_dir_time = 0

var next_jump_time = -1

var target_player_dist = 40

var eye_reach = 90
var vision = 600

var vertical_movement = 0
var horizontal_movement = 200

func _ready():
	set_process(true)
	randomize()
	#Generate random negative number betweeen 400 and 800
	vertical_movement = -1 * ( (randi() % 800) + 400 )
	#Generate random number betweeen 200 and 700
	horizontal_movement = (randi() % 700) + 200 
	print(randi())

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0, -eye_reach)
	var eye_left = eye_center + Vector2(-eye_reach, 0)
	var eye_right = eye_center + Vector2(eye_reach, 0)

	var player_pos = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1, 1)
	var top_left = player_pos + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x, player_extents.y)

	var space_state = get_world_2d().direct_space_state

	for eye in [eye_center, eye_top, eye_left, eye_right]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if (corner - eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1) # collision mask = sum of 2^(collision layers) - e.g 2^0 + 2^3 = 9
			if collision and collision.collider.name == "Player":
				return true
	return false

func _process(delta):
	if !dead:
		movement(delta)

func movement(delta):
	if Player.position.x < position.x - target_player_dist and sees_player():
		set_dir(-1)
	elif Player.position.x > position.x + target_player_dist and sees_player():
		set_dir(1)
	else:
		set_dir(0)

	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir

	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - 64 and sees_player():
			vel.y = vertical_movement
		next_jump_time = -1

	vel.x = dir * horizontal_movement

	if Player.position.y < position.y - 64 and next_jump_time == -1 and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time

	vel.y += grav * delta;
	if vel.y > max_grav:
		vel.y = max_grav

	if is_on_floor() and vel.y > 0:
		vel.y = 0

	vel = move_and_slide(vel, Vector2(0, -1))


func kill():
	dead = true
	$AnimationPlayer.play("Dead")
	$Sprite.modulate = Color(0,1,0)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()


func _on_Area2D_body_entered(body):
	if(body.name == "Player" and not dead):
		body.player_hurt(5)
