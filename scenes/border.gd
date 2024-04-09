extends Area2D

@onready var label = $"../../CanvasLayer/Label"
@onready var label2 = $"../../CanvasLayer/Label2"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if(body.has_method("get_infected")):
		var numb = randi_range(1,10)
		if (numb != 1):
			label.visible = true;
			await get_tree().create_timer(2).timeout
			label.visible = false;
		else:
			label2.visible = true;
			await get_tree().create_timer(2).timeout
			label2.visible = false;
