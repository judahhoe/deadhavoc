extends Control

@onready var MaxFpsLabel = $TabContainer/Video/MarginContainer/GridContainer/HBoxContainer/MaxFps
@onready var FpsCounter = $FpsCounter

@onready var MasterSlider = $TabContainer/Audio/MarginContainer/GridContainer/MasterSlider
@onready var MusicSlider = $TabContainer/Audio/MarginContainer/GridContainer/MusicSlider
@onready var SfxSlider = $TabContainer/Audio/MarginContainer/GridContainer/SFXSlider

@onready var DisplayModeDropdown = $TabContainer/Video/MarginContainer/GridContainer/DisplayModeDropdown
@onready var VsyncButton = $TabContainer/Video/MarginContainer/GridContainer/VsyncButton
@onready var FpsSlider = $TabContainer/Video/MarginContainer/GridContainer/HBoxContainer/FPSSlider

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SfxBus = AudioServer.get_bus_index("SoundEffects")

var SelectedFps = 60
var db #database object 
var db_name = "res://DataStore/database" #Path to DB
var nick = "test_user"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_settings_from_db()
	get_settings_from_db()
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
	
func get_settings_from_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	#remember to not use variables inside the query somehow connected with other variables names, it's not working properly
	db.query("SELECT user_configuration.master_sound, user_configuration.music, user_configuration.sound_effects, user_configuration.display_mode, user_configuration.vsync, user_configuration.fps_cap from user INNER JOIN user_configuration ON user.id = user_configuration.user_id where user.nickname = '" + nick + "';")
	var master_sound_query = db.query_result[0]["master_sound"]#float (0-1 scope)
	var music_query = db.query_result[0]["music"]#float (0-1 scope)
	var sound_effects_query = db.query_result[0]["sound_effects"]#float (0-1 scope)
	var display_mode_query = db.query_result[0]["display_mode"]#text
	var vsync_query = db.query_result[0]["vsync"]#int(0 - off;1 - on)
	var fps_cap_query = db.query_result[0]["fps_cap"]#int

	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(master_sound_query))
	MasterSlider.value = master_sound_query
	
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(music_query))
	MusicSlider.value = music_query
	
	AudioServer.set_bus_volume_db(SfxBus, linear_to_db(sound_effects_query))
	SfxSlider.value = music_query
	
	if(display_mode_query == "windowed"): #windowed
		DisplayServer.window_set_mode(0)
		DisplayServer.window_set_flag(1, false)
		DisplayServer.window_set_size(Vector2i(1024,768))
		DisplayModeDropdown.selected = 0
	if(display_mode_query == "fullscreen"): #fullscreen
		DisplayServer.window_set_mode(4)
		DisplayModeDropdown.selected = 1
	if(display_mode_query == "borderless"): #borderless
		DisplayServer.window_set_mode(3)
		DisplayModeDropdown.selected = 2
		
	if(vsync_query == 1):
		DisplayServer.window_set_vsync_mode(1)
		VsyncButton.button_pressed = true
	if(vsync_query == 0):
		DisplayServer.window_set_vsync_mode(0)
		VsyncButton.button_pressed = false
		
	if(fps_cap_query == 0):
		MaxFpsLabel.text = "Unlimited"
	else:
		MaxFpsLabel.text = str(fps_cap_query)
	SelectedFps = fps_cap_query
	Engine.max_fps = SelectedFps
	FpsSlider.value = fps_cap_query
	
