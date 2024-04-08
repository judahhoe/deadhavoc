extends Node2D

const BULLET_IMPACT = preload("res://scenes/bullet_impact.tscn")

const BULLET_IMPACT_KILL = preload("res://scenes/bullet_impact2.tscn")

func _ready() -> void:
		get_node(".").connect("bullet_impacted",handle_bullet_impacted)
		get_node(".").connect("impact_kill",handle_kill)
		
func handle_bullet_impacted(position:Vector2,direction:Vector2):
	var impact = BULLET_IMPACT.instantiate()
	print("TEST IMPACTED")
	add_child(impact)
	impact.global_position = position
	impact.global_rotation = direction.angle()
	impact.emitting = true
	
func handle_kill(position:Vector2):
	var impact = BULLET_IMPACT_KILL.instantiate()
	add_child(impact)
	impact.global_position = position
	impact.emitting = true
	
