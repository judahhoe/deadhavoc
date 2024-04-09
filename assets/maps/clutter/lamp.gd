extends Node2D

@onready var timer = $"Timer"
@onready var light = $"PointLight2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = randi_range(5,20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	timer.wait_time = randi_range(5,20)
	light.energy = 0.1;
	await get_tree().create_timer(0.1).timeout
	light.energy = 0.3;
	await get_tree().create_timer(0.1).timeout
	light.energy = 0.1;
	await get_tree().create_timer(0.1).timeout
	light.energy = 0.2;
	await get_tree().create_timer(0.1).timeout
	light.energy = 0.5;
