extends Node2D

@onready var blood = $"Sprite2D"
@onready var sprite1 = preload("res://textures/blood_pool_1.png")
@onready var sprite2 = preload("res://textures/blood_pool_2.png")
@onready var sprite3 = preload("res://textures/blood_pool_3.png")
@onready var sprite4 = preload("res://textures/blood_pool_4.png")
@onready var vanishing = $"AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	var ran = randi_range(1,4)
	if(ran == 1):
		blood.texture = sprite1
	if(ran == 2):
		blood.texture = sprite2
	if(ran == 3):
		blood.texture = sprite3
	if(ran == 4):
		blood.texture = sprite4
	scale *= randf_range(1.0,2.0)
	vanishing.play("blood_vanish")


func delete():
	queue_free()
