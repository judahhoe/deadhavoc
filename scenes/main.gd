extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $player
@onready var crosshair = preload("res://textures/crosshair.png")
@onready var cursor = preload("res://textures/cursor.png")
var isPaused = false
@onready var pause_menu = $"Pause/PauseMenu"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	if(event.is_action_pressed("pause")):
		if(isPaused):
			unpause()
		if(!isPaused):
			pause()

func pause():
	isPaused = true
	Input.set_custom_mouse_cursor(cursor)
	get_tree().paused = true
	pause_menu.show()


func unpause():
	isPaused = false
	Input.set_custom_mouse_cursor(crosshair)
	pause_menu.hide()
	get_tree().paused = false


func _on_button_pressed():
	unpause()


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().quit()


func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")
