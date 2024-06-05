extends Control

@onready var adduserbutton = $VBoxContainer/HBoxContainer/AddUserButton
@onready var removeuserbutton = $VBoxContainer/HBoxContainer/RemoveUserButton
@onready var enterbutton = $VBoxContainer/HBoxContainer/EnterButton
@onready var quitbutton = $VBoxContainer/QuitButton
@onready var profile1button = $VBoxContainer/Profile1
@onready var profile2button = $VBoxContainer/Profile2
@onready var profile3button = $VBoxContainer/Profile3
@onready var profile4button = $VBoxContainer/Profile4
@onready var profile5button = $VBoxContainer/Profile5
@onready var profile6button = $VBoxContainer/Profile6
@onready var sound = $ButtonClickSplatter
@onready var nicknamefield = $VBoxContainer/NicknameField

@onready var cursor = preload("res://textures/cursor.png")

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SfxBus = AudioServer.get_bus_index("SoundEffects")

var SelectedFps = 60
var db #database object 
var db_name = "user://data/database" #Path to DB
var nick = "test_user"
var profile_indicator = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	if not FileAccess.file_exists(db_name):
		create_db()
	else:
		print("Database already exists.")
	adjust_profiles()
	nicknamefield.grab_focus()
	#if(!BackgroundMusic.isMusicPlaying):
		#BackgroundMusic.play_music()
		
func create_db():
	# Create db directory
	var dir = DirAccess.make_dir_absolute("user://data")
	# Create an instance of the SQLite object
	db = SQLite.new()
	db.path = db_name
	# Open the database (will create the file if it doesn't exist)
	var success = db.open_db()
	
	if !success:
		print("Failed to open or create database: ", success)
		return
	
	# Example of creating a table
	var create_table_query = """
	CREATE TABLE "achievement" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"description"	TEXT NOT NULL,
	"reward"	TEXT,
	"user_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	var result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
		
	create_table_query = """
	CREATE TABLE "level_completed" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"user_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	
	create_table_query = """
	CREATE TABLE "perks" (
	"id"	INTEGER NOT NULL UNIQUE,
	"player_health"	INTEGER,
	"movement_speed"	INTEGER,
	"weapons_recoil"	INTEGER,
	"max_ammo"	INTEGER,
	"reload_speed"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	create_table_query = """
	CREATE TABLE "shop" (
	"id"	INTEGER NOT NULL UNIQUE,
	"type"	TEXT,
	"class"	TEXT,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	"cost"	NUMERIC NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	create_table_query = """
	CREATE TABLE sqlite_sequence(name,seq)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	create_table_query = """
	CREATE TABLE "transaction" (
	"id"	INTEGER NOT NULL UNIQUE,
	"user_id"	INTEGER NOT NULL,
	"shop_id"	INTEGER NOT NULL,
	"discount"	NUMERIC,
	"total_cost"	NUMERIC NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	create_table_query = """
	CREATE TABLE "user" (
	"id"	INTEGER NOT NULL UNIQUE,
	"nickname"	TEXT NOT NULL UNIQUE,
	"email"	NUMERIC UNIQUE,
	"password"	TEXT,
	"experience"	INTEGER,
	"coins"	NUMERIC,
	"money"	NUMERIC,
	"skillpoints"	NUMERIC,
	"level"	NUMERIC,
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	create_table_query = """
	CREATE TABLE "user_configuration" (
	"user_id"	INTEGER NOT NULL UNIQUE,
	"master_sound"	NUMERIC NOT NULL,
	"music"	NUMERIC NOT NULL,
	"sound_effects"	NUMERIC NOT NULL,
	"display_mode"	TEXT NOT NULL,
	"vsync"	INTEGER NOT NULL,
	"fps_cap"	INTEGER NOT NULL,
	PRIMARY KEY("user_id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
)	
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	
	create_table_query = """
	CREATE TABLE "user_data" (
	"user_id"	INTEGER NOT NULL UNIQUE,
	"time_spent"	INTEGER,
	"coins_spent"	NUMERIC,
	"levels_passed"	INTEGER,
	"zombies_killed"	INTEGER,
	PRIMARY KEY("user_id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	
	create_table_query = """
	CREATE TABLE "weapons" (
	"id"	INTEGER NOT NULL UNIQUE,
	"sidearm"	INTEGER,
	"rifle"	INTEGER,
	"shotgun"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
)
	"""
	# Execute the query
	result = db.query(create_table_query)
	
	if !result:
		print("Failed to create table")
	else:
		print("Table created successfully.")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.d
func _process(delta):
	pass

func _on_quit_button_pressed():
	sound.play()
	#quitbutton.icon = load("res://assets/menus/menu_plank_bloody_3.png")
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


func _on_adduser_button_pressed():
	sound.play()
	create_user()

func _on_adduser_button_focus_entered():
	adduserbutton.modulate = "909090"
	adduserbutton.grab_focus()


func _on_adduser_button_focus_exited():
	adduserbutton.modulate = "ffffff"
	adduserbutton.release_focus()


func _on_adduser_button_mouse_entered():
	adduserbutton.modulate = "909090"
	adduserbutton.grab_focus()


func _on_adduser_button_mouse_exited():
	adduserbutton.modulate = "ffffff"
	adduserbutton.release_focus()


func _on_removeuser_button_pressed():
	remove_user()

func _on_removeuser_button_focus_entered():
	removeuserbutton.modulate = "909090"
	removeuserbutton.grab_focus()


func _on_removeuser_button_focus_exited():
	removeuserbutton.modulate = "ffffff"
	removeuserbutton.release_focus()


func _on_removeuser_button_mouse_entered():
	removeuserbutton.modulate = "909090"
	removeuserbutton.grab_focus()


func _on_removeuser_button_mouse_exited():
	removeuserbutton.modulate = "ffffff"
	removeuserbutton.release_focus()
	
func create_user():
	var user_created = false
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("select nickname from user;")
	nick = nicknamefield.text
	if db.query_result.size()>=6:
		var message = "Maksymalna liczba użytkowników!"
		OS.alert(message)
	elif nick == '':
		var message = "Nazwa użytkownika nie może być pusta!"
		OS.alert(message)
	else:
		var user_exist = false
		for i in db.query_result.size():
			if nick == db.query_result[i].nickname:
				var message = "Użytkownik już istnieje!"
				OS.alert(message)
				user_exist = true
				break
		if user_exist == false:
			create_user_in_db()
			adjust_profiles()
			
func create_user_in_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("insert into user (nickname, experience, coins, money, skillpoints, level) values ('" + nick  + "', 0, 0, 0, 0, 1);")
	db.query("select max(id) as id from user;")
	var id = str(db.query_result[0].id)
	db.query("insert into perks (id, player_health, movement_speed, weapons_recoil, max_ammo, reload_speed) values (" + id + ",0, 0, 0, 0, 0);")
	db.query("insert into weapons (id, sidearm, rifle, shotgun) values (" + id + ", 0, 0, 0);")
	db.query("insert into user_configuration (user_id, master_sound, music, sound_effects, display_mode, vsync, fps_cap) values (" + id + ",0.5, 0.5, 0.5, 'fullscreen', 1, 60);")
		
func adjust_profiles():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("select nickname from user order by id;")
	
	if db.query_result.size()>0:
		profile1button.text = db.query_result[0].nickname
		profile1button.visible = true
	
	if db.query_result.size()>1:
		profile2button.text = db.query_result[1].nickname
		profile2button.visible = true
	
	if db.query_result.size()>2:
		profile3button.text = db.query_result[2].nickname
		profile3button.visible = true
	
	if db.query_result.size()>3:
		profile4button.text = db.query_result[3].nickname
		profile4button.visible = true
	
	if db.query_result.size()>4:
		profile5button.text = db.query_result[4].nickname
		profile5button.visible = true
		
	if db.query_result.size()>5:
		profile6button.text = db.query_result[5].nickname
		profile6button.visible = true
	
func _on_enter_button_pressed():
	if profile_indicator == 0:
		var message = "Nie wybrano użytkownika!"
		OS.alert(message)
	else:
		if profile_indicator==1:
			GlobalVariables.nickname = profile1button.text 
		if profile_indicator==2:
			GlobalVariables.nickname = profile2button.text 
		if profile_indicator==3:
			GlobalVariables.nickname = profile3button.text 
		if profile_indicator==4:
			GlobalVariables.nickname = profile4button.text 
		if profile_indicator==5:
			GlobalVariables.nickname = profile5button.text 
		if profile_indicator==6:
			GlobalVariables.nickname = profile6button.text 
			
		sound.play()
		#enterbutton.icon = load("res://assets/menus/menu_plank_enter_bloody.png")
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")
	
func _on_enter_button_focus_entered():
	enterbutton.modulate = "909090"
	enterbutton.grab_focus()

func _on_enter_button_focus_exited():
	enterbutton.modulate = "ffffff"
	enterbutton.release_focus()

func _on_enter_button_mouse_entered():
	enterbutton.modulate = "909090"
	enterbutton.grab_focus()

func _on_enter_button_mouse_exited():
	enterbutton.modulate = "ffffff"
	enterbutton.release_focus()

func _on_profile_1_pressed():
	change_button_indicator(1)

func _on_profile_2_pressed():
	change_button_indicator(2)

func _on_profile_3_pressed():
	change_button_indicator(3)

func _on_profile_4_pressed():
	change_button_indicator(4)

func _on_profile_5_pressed():
	change_button_indicator(5)

func _on_profile_6_pressed():
	change_button_indicator(6)
	
func change_button_indicator(index):
	profile1button.modulate = "ffffff"
	profile2button.modulate = "ffffff"
	profile3button.modulate = "ffffff"
	profile4button.modulate = "ffffff"
	profile5button.modulate = "ffffff"
	profile6button.modulate = "ffffff"
		
	if index==1:
		profile1button.modulate = "666666"
		profile_indicator = 1
	
	if index==2:
		profile2button.modulate = "666666"
		profile_indicator = 2
		
	if index==3:
		profile3button.modulate = "666666"
		profile_indicator = 3
				
	if index==4:
		profile4button.modulate = "666666"
		profile_indicator = 4
		
	if index==5:
		profile5button.modulate = "666666"
		profile_indicator = 5
		
	if index==6:
		profile6button.modulate = "666666"
		profile_indicator = 6
		
func remove_user():
	if profile_indicator == 0:
		var message = "Nie wybrano użytkownika!"
		OS.alert(message)
	else:
		db = SQLite.new()
		db.path = db_name
		db.open_db()
		db.query("select id from user order by id;")
		var id = str(db.query_result[profile_indicator-1].id)
		db.query("delete from user where id = " + id + " ;")
		profile1button.visible = false
		profile2button.visible = false
		profile3button.visible = false
		profile4button.visible = false
		profile5button.visible = false
		profile6button.visible = false
		adjust_profiles()
		profile_indicator = 0
		change_button_indicator(profile_indicator)
