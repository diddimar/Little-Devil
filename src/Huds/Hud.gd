extends Node

var positions = [ Vector2(32,32), Vector2(56,32), Vector2(80,32) ]

func remove_live():
	var live = $CanvasLayer.get_child($CanvasLayer.get_child_count() - 1)
	$CanvasLayer.remove_child(live)


func _ready():
	for i in range(Globals.lives):
		add_live_sprites(i)


func add_live_sprites(position: int):
	var sprite = Sprite.new()
	sprite.texture = load("res://Assets/Graphics/Player/player_head.png")
#	sprite.scale = Vector2(0.25, 0.25)
	sprite.position = positions[position]
	$CanvasLayer.add_child(sprite)

