extends Control

@onready var loginbutton = $VBoxContainer/HBoxContainer/LoginButton
@onready var registerbutton = $VBoxContainer/HBoxContainer/RegisterButton
@onready var quitbutton = $VBoxContainer/QuitButton
@onready var sound = $ButtonClickSplatter
@onready var login = $VBoxContainer/LoginField
@onready var password = $VBoxContainer/PasswordField

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SfxBus = AudioServer.get_bus_index("SoundEffects")

var SelectedFps = 60
var db #database object 
var db_name = "res://DataStore/database" #Path to DB
var nick = "test_user"
# Called when the node enters the scene tree for the first time.
func _ready():
	login.grab_focus()
	if(!BackgroundMusic.isMusicPlaying):
		BackgroundMusic.play_music()
# Called every frame. 'delta' is the elapsed time since the previous frame.d
func _process(delta):
	pass

func _on_quit_button_pressed():
	sound.play()
	quitbutton.icon = load("res://assets/menus/menu_plank_bloody_3.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _on_quit_button_focus_entered():
	quitbutton.modulate = "909090"
	quitbutton.grab_focus()


func _on_quit_button_focus_exited():
	quitbutton.modulate = "ffffff"
	quitbutton.release_focus()


func _on_quit_button_mouse_entered():
	quitbutton.modulate = "909090"
	quitbutton.grab_focus()


func _on_quit_button_mouse_exited():
	quitbutton.modulate = "ffffff"
	quitbutton.release_focus()


func _on_login_button_pressed():
	sound.play()
	var user_found = await check_if_proper_login_data()
	if user_found==true:
		loginbutton.icon = load("res://assets/menus/login_plank_1.png")

func _on_login_button_focus_entered():
	loginbutton.modulate = "909090"
	loginbutton.grab_focus()


func _on_login_button_focus_exited():
	loginbutton.modulate = "ffffff"
	loginbutton.release_focus()


func _on_login_button_mouse_entered():
	loginbutton.modulate = "909090"
	loginbutton.grab_focus()


func _on_login_button_mouse_exited():
	loginbutton.modulate = "ffffff"
	loginbutton.release_focus()


func _on_register_button_pressed():
	sound.play()
	registerbutton.icon = load("res://assets/menus/register_plank_1.png")


func _on_register_button_focus_entered():
	registerbutton.modulate = "909090"
	registerbutton.grab_focus()


func _on_register_button_focus_exited():
	registerbutton.modulate = "ffffff"
	registerbutton.release_focus()


func _on_register_button_mouse_entered():
	registerbutton.modulate = "909090"
	registerbutton.grab_focus()


func _on_register_button_mouse_exited():
	registerbutton.modulate = "ffffff"
	registerbutton.release_focus()
	
func check_if_proper_login_data() -> bool:
	nick = login.text
	var login_to_check = nick
	var password_to_check = password.text
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	db.query("SELECT * from user where nickname = '" + login_to_check + "' and password = '" + password_to_check + "';")
	var user_found = false
	if db.query_result.size()>0:
		user_found = true
	if user_found == false:
		var message = "Błędne dane logowania! spróbuj ponownie."
		OS.alert(message)
	else:
		sound.play()
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")
	return user_found
