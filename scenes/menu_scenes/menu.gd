extends Control

@onready var playbutton = $VBoxContainer/PlayButton
@onready var perksbutton = $VBoxContainer/PerksButton
@onready var optionsbutton = $VBoxContainer/OptionsButton
@onready var quitbutton = $VBoxContainer/QuitButton
@onready var sound = $ButtonClickSplatter

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SfxBus = AudioServer.get_bus_index("SoundEffects")

@onready var cursor = preload("res://textures/cursor.png")

var SelectedFps = 60
var db #database object 
var db_name = "user://data/database" #Path to DB
var nick = GlobalVariables.nickname
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_settings_from_db()
	get_settings_from_db()
	playbutton.grab_focus()
	if(!BackgroundMusic.isMusicPlaying):
		BackgroundMusic.play_music()
# Called every frame. 'delta' is the elapsed time since the previous frame.d
func _process(delta):
	pass


func _on_play_button_pressed():
	sound.play()
	playbutton.icon = load("res://assets/menus/menu_plank_bloody_0.png")
	await get_tree().create_timer(0.2).timeout
	if(BackgroundMusic.isMusicPlaying):
		BackgroundMusic.stop_music()
	get_tree().change_scene_to_packed(load("res://scenes/menu_scenes/loading_screen.tscn"))
	#get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_perks_button_pressed():
	sound.play()
	perksbutton.icon = load("res://assets/menus/menu_plank_bloody_1.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/menu_scenes/perks_menu/skill_tree.tscn")


func _on_options_button_pressed():
	sound.play()
	optionsbutton.icon = load("res://assets/menus/menu_plank_bloody_2.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_options.tscn")


func _on_quit_button_pressed():
	sound.play()
	quitbutton.icon = load("res://assets/menus/menu_plank_bloody_3.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func _on_play_button_mouse_entered():
	playbutton.modulate = "909090"
	playbutton.grab_focus()


func _on_play_button_mouse_exited():
	playbutton.modulate = "ffffff"
	playbutton.release_focus()

func _on_play_button_focus_entered():
	playbutton.modulate = "909090"
	playbutton.grab_focus()


func _on_play_button_focus_exited():
	playbutton.modulate = "ffffff"
	playbutton.release_focus()


func _on_perks_button_mouse_entered():
	perksbutton.modulate = "909090"
	perksbutton.grab_focus()


func _on_perks_button_mouse_exited():
	perksbutton.modulate = "ffffff"
	perksbutton.release_focus()

func _on_perks_button_focus_entered():
	perksbutton.modulate = "909090"
	perksbutton.grab_focus()


func _on_perks_button_focus_exited():
	perksbutton.modulate = "ffffff"
	perksbutton.release_focus()

func _on_options_button_mouse_entered():
	optionsbutton.modulate = "909090"
	optionsbutton.grab_focus()


func _on_options_button_mouse_exited():
	optionsbutton.modulate = "ffffff"
	optionsbutton.release_focus()

func _on_options_button_focus_entered():
	optionsbutton.modulate = "909090"
	optionsbutton.grab_focus()


func _on_options_button_focus_exited():
	optionsbutton.modulate = "ffffff"
	optionsbutton.release_focus()

func _on_quit_button_mouse_entered():
	quitbutton.modulate = "909090"
	quitbutton.grab_focus()


func _on_quit_button_mouse_exited():
	quitbutton.modulate = "ffffff"
	quitbutton.release_focus()


func _on_quit_button_focus_entered():
	quitbutton.modulate = "909090"
	quitbutton.grab_focus()


func _on_quit_button_focus_exited():
	quitbutton.modulate = "ffffff"
	quitbutton.release_focus()
func get_settings_from_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	#remember to not use variables inside the query connected with other variables, it's not working properly
	db.query("SELECT user_configuration.master_sound, user_configuration.music, user_configuration.sound_effects, user_configuration.display_mode, user_configuration.vsync, user_configuration.fps_cap from user INNER JOIN user_configuration ON user.id = user_configuration.user_id where user.nickname = '" + nick + "';")
	var master_sound_query = db.query_result[0]["master_sound"]#float(scope 0-1)
	var music_query = db.query_result[0]["music"]#float(scope 0-1)
	var sound_effects_query = db.query_result[0]["sound_effects"]#float(scope 0-1)
	var display_mode_query = db.query_result[0]["display_mode"]#text
	var vsync_query = db.query_result[0]["vsync"]#int(0 - off;1 - on)
	var fps_cap_query = db.query_result[0]["fps_cap"]#int

	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(master_sound_query))
	
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(music_query))
	
	AudioServer.set_bus_volume_db(SfxBus, linear_to_db(sound_effects_query))
	
	if(display_mode_query == "windowed"): #windowed
		DisplayServer.window_set_mode(0)
		DisplayServer.window_set_flag(1, false)
		DisplayServer.window_set_size(Vector2i(1024,768))
	if(display_mode_query == "fullscreen"): #fullscreen
		DisplayServer.window_set_mode(4)
	if(display_mode_query == "borderless"): #borderless
		DisplayServer.window_set_mode(3)
		
	if(vsync_query == 1):
		DisplayServer.window_set_vsync_mode(1)
	if(vsync_query == 0):
		DisplayServer.window_set_vsync_mode(0)
		
	SelectedFps = fps_cap_query
	Engine.max_fps = SelectedFps
