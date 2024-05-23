extends Node2D

@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("vanish")


func delete():
	queue_free()
