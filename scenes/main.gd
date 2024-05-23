extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $player
@onready var crosshair = preload("res://textures/crosshair.png")
@onready var cursor = preload("res://textures/cursor.png")
var isPaused = false
@onready var pause_menu = $"Pause/PauseMenu"
@onready var controls_menu = $"Controls/ControlsMenu"
@onready var music = $BackgroundMusic

@onready var label = $CanvasLayer/Label
@onready var suitcase = $suitcase
@onready var gascan = $gascan

@onready var objectiveSpawnpoints = $ObjectiveSpawnpoints


# Called when the node enters the scene tree for the first time.
func _ready():
	isPaused = true
	Input.set_custom_mouse_cursor(cursor)
	get_tree().paused = true
	controls_menu.show()
	#spawn objective
	var suitcaseSpawnID = randi_range(1,21)
	suitcase.global_position = objectiveSpawnpoints.get_child(suitcaseSpawnID).global_position
	var gascanSpawnID = randi_range(1,21)
	while gascanSpawnID == suitcaseSpawnID:
		gascanSpawnID = randi_range(1,21)
	gascan.global_position = objectiveSpawnpoints.get_child(gascanSpawnID).global_position
	
	music.play()
	await get_tree().create_timer(5).timeout
	label.visible = true
	await get_tree().create_timer(5).timeout
	label.visible = false
	
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


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
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	pause_menu.show()


func unpause():
	isPaused = false
	Input.set_custom_mouse_cursor(crosshair)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pause_menu.hide()
	controls_menu.hide()
	get_tree().paused = false


func _on_button_pressed():
	Input.set_custom_mouse_cursor(crosshair)
	unpause()


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().quit()


func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")
