extends Control
@onready var cursor = preload("res://textures/cursor.png")
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	animation.play("splash")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
		get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")
