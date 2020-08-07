extends Node

onready var health_bar = $TextureProgress

func on_health_updated(health):
	health_bar.value = health


func on_max_health_updated(max_health):
	health_bar.max_value = max_health
