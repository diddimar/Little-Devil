extends Node2D

onready var playerAnimation = $PlayerAnimation
onready var gunAnimation = $GunAnimation
 

# Arguments: flip: bool, running: bool, shooting: bool, dead: bool
func _on_Player_animate_movement(flip, running, shooting, hurt_dead):
	if not flip:
		$Player.flip_h = false
		$GunSheet.flip_h = false
		$GunSheet.position.x = 12
	if flip:
		$Player.flip_h = true
		$GunSheet.flip_h = true
		$GunSheet.position.x = -12
	if shooting[0]:
		gunAnimation.play("shoot")
	if shooting[1]:
		gunAnimation.play("reload")
	if hurt_dead[0]:
		playerAnimation.play("hurt")
	if running:
		playerAnimation.play("run")



