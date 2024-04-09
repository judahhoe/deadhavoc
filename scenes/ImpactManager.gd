extends Node2D

const BULLET_IMPACT = preload("res://scenes/bullet_impact.tscn")

const BULLET_IMPACT_KILL = preload("res://scenes/bullet_impact2.tscn")

func _ready() -> void:
		get_node(".").connect("bullet_impacted",handle_bullet_impacted)
		
func handle_bullet_impacted(position:Vector2,direction:Vector2):
	var impact = BULLET_IMPACT.instantiate()
	print("TEST IMPACTED")
	add_child(impact)
	impact.global_position = position
	impact.global_rotation = direction.angle()
	impact.emitting = true
		
	

