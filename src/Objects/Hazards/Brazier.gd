extends StaticBody2D


func _ready():
	pass


func _on_HurtArea2D_body_entered(body):
	if(body.has_method("player_entered_hazard")):
		body.player_entered_hazard(15)
