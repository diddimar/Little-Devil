extends KinematicBody2D


# Variables for moving around
const FLOOR_NORMAL = Vector2.UP
const WALK_SPEED: = 300
const GRAVITY = 2800
const JUMP_SPEED = 1100
const friction: float = 0.1
const acceleration: float = 0.25
var velocity = Vector2(0,0)


# Used to calculate facing direction
var vertical_position = 0.0
var flip_sprite = false

signal animate_movement
signal animate_gun

var hurt_dead = [false, false]
const GUNSHOT = preload("res://src/Actors/GunShot.tscn")
var bullets = 6
var can_shoot = true

func _ready():
	pass


func _physics_process(delta):
	handle_movement(delta)
	handle_animation()
	check_zoom()

func handle_movement(delta):
	# Handle horizontal movement
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * WALK_SPEED, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, acceleration)
	# Handle vertical movement
	velocity.y += GRAVITY * delta
	handle_jump()
	# Move
	velocity = move_and_slide(velocity, FLOOR_NORMAL)


func handle_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -JUMP_SPEED


func handle_animation():
	var shooting: Array = handle_shooting()
	var running: bool = (velocity.x > 180 or velocity.x < -180) and is_on_floor()

	# Check wich direction player is facing
	# Plus or minus 1 for margin when hitting walls
	if(global_position.x > (vertical_position + 1) ):
		# Is moving right
		flip_sprite = false
	elif(global_position.x < (vertical_position - 1) ):
		# Is moving left
		flip_sprite = true

	emit_signal("animate_movement", flip_sprite, running, shooting, hurt_dead)

	vertical_position += global_position.x - vertical_position


## Shooting Start - returns is_shooting and has_to_reload
func handle_shooting() -> Array:
	set_gunshot_start_position()
	var is_shooting = is_shooting()
	var has_to_reload = has_to_reload()
	return [is_shooting, has_to_reload]

func is_shooting() -> bool:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var gunshot = GUNSHOT.instance()
		gunshot.position = $FirePosition2D.global_position
		if sign($FirePosition2D.position.x) == -1:
			gunshot.direction = -1
		else:
			gunshot.direction = 1
	
		get_parent().add_child(gunshot)
		shot_fired()
		return true
	else:
		return false

func shot_fired():
	yield(get_tree().create_timer(0.2), "timeout")
	bullets -= 1

func has_to_reload() -> bool:
	if bullets == 0:
		reload()
		return true
	else:
		return false

func reload():
	can_shoot = false
	bullets = 6
	yield(get_tree().create_timer(0.8), "timeout")
	can_shoot = true

func set_gunshot_start_position():
	if Input.is_action_pressed("move_right"):
		if sign($FirePosition2D.position.x) == -1:
			$FirePosition2D.position.x *= -1
	if Input.is_action_pressed("move_left"):	
		if sign($FirePosition2D.position.x) == 1:
			$FirePosition2D.position.x *= -1
## Shooting End


func player_death():
	hurt_dead[1] = true
	#emit_signal("animate_movement", Vector2(0,0), is_on_floor(), dead, false)
	yield(get_tree().create_timer(2.0), "timeout")
	var point_B = Vector2(495, 645)
	position = point_B
	$Camera2D.zoom = Vector2(1, 1)
	hurt_dead[1] = false

func player_entered_hazard():
	player_hurt()
	velocity = hurt_impulse()

func hurt_impulse() -> Vector2:
	var out = velocity
	out.y = -800
	# Ternary operator
	out.x = -400 if flip_sprite else 400
	return out

func player_hurt():
	hurt_dead[0] = true
	can_shoot = false
	yield(get_tree().create_timer(0.3), "timeout")
	hurt_dead[0] = false
	can_shoot = true



func check_zoom():
	if Input.is_action_just_pressed("zoom_in"):
		$Camera2D.zoom = Vector2(0.5, 0.5)
		$Camera2D.drag_margin_h_enabled = false
		$Camera2D.drag_margin_top = 0.4
	if Input.is_action_just_pressed("zoom_out"):
		$Camera2D.zoom = Vector2(1, 1)
		$Camera2D.drag_margin_h_enabled = true
		$Camera2D.drag_margin_top = 0.2


