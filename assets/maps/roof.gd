extends Node2D
@onready var texture = $"TextureRect"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if(body.has_method("get_infected")):
		texture.modulate = "ffffff3f"


func _on_area_2d_body_exited(body):
	if(body.has_method("get_infected")):
		texture.modulate = "ffffffff"
