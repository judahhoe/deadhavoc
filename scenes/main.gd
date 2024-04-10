extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $player
@onready var crosshair = preload("res://textures/crosshair.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
