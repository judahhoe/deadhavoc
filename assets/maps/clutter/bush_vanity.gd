extends Node2D

@onready var sprite = $"Sprite2D"

func _on_area_2d_body_entered(body):
	if(body.has_method("get_infected")):
		sprite.modulate = "ffffff4e"


func _on_area_2d_body_exited(body):
	if(body.has_method("get_infected")):
		sprite.modulate = "ffffffff"
