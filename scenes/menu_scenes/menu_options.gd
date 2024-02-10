extends Control

@onready var MaxFpsLabel = $TabContainer/Video/MarginContainer/GridContainer/HBoxContainer/MaxFps
@onready var FpsCounter = $FpsCounter

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SfxBus = AudioServer.get_bus_index("SoundEffects")

var SelectedFps = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	FpsCounter.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_vsync_button_toggled(toggled_on):
	if(toggled_on):
		DisplayServer.window_set_vsync_mode(1)
	else:
		DisplayServer.window_set_vsync_mode(0)

func _on_display_mode_dropdown_item_selected(index):
	if(index == 0): #windowed
		DisplayServer.window_set_mode(0)
		DisplayServer.window_set_flag(1, false)
		DisplayServer.window_set_size(Vector2i(1024,768))
	if(index == 1): #fullscreen
		DisplayServer.window_set_mode(4)
	if(index == 2): #borderless
		DisplayServer.window_set_mode(3)

func _on_fps_slider_drag_ended(value_changed):
	if(value_changed):
		Engine.max_fps = SelectedFps
		print(Engine.max_fps)

func _on_fps_slider_value_changed(value):
	if(value == 0):
		MaxFpsLabel.text = "Unlimited"
	else:
		MaxFpsLabel.text = str(value)
	SelectedFps = value

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SfxBus, linear_to_db(value))
