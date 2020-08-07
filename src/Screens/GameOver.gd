extends Control

var quit_label: Label
var percent: float = 0.0


func _ready():
	quit_label = get_node("CenterContainer/VBoxContainer/GameOverLabel")

func _process(delta):
	if percent < 1.0:
		percent += 0.025
		quit_label.percent_visible = percent


func _on_TryAgainButton_pressed():
	Globals.lives = 3
	get_tree().change_scene("res://src/Levels/LevelTemplate.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
