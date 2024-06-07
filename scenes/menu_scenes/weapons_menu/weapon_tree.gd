extends Control

#buttons

@onready var pistolbutton = $PistolButton
@onready var revolverbutton = $RevolverButton
@onready var riflebutton = $RifleButton
@onready var akbutton = $AkButton
@onready var shotgunbutton = $ShotgunButton
@onready var pumpbutton = $PumpButton

var db #database object 
var db_name = "user://data/database" #Path to DB
@onready var nick = GlobalVariables.nickname

var sidearm
var rifle
var shotgun

# Called when the node enters the scene tree for the first time.
func _ready():
	get_settings_from_db()
	if(sidearm == 0):
		pistolbutton.modulate = "00ff00"
	if(sidearm == 1):
		revolverbutton.modulate = "00ff00"
	if(rifle == 0):
		riflebutton.modulate = "00ff00"
	if(rifle == 1):
		akbutton.modulate = "00ff00"
	if(shotgun == 0):
		shotgunbutton.modulate = "00ff00"
	if(shotgun == 1):
		pumpbutton.modulate = "00ff00"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_apply_button_pressed():
	update_db_perks()


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")


func _on_pump_button_pressed():
	pumpbutton.modulate = "00ff00"
	shotgunbutton.modulate = "ffffff"
	shotgun = 1


func _on_shotgun_button_pressed():
	shotgunbutton.modulate = "00ff00"
	pumpbutton.modulate = "ffffff"
	shotgun = 0


func _on_ak_button_pressed():
	akbutton.modulate = "00ff00"
	riflebutton.modulate = "ffffff"
	rifle = 1


func _on_rifle_button_pressed():
	riflebutton.modulate = "00ff00"
	akbutton.modulate = "ffffff"
	rifle = 0


func _on_revolver_button_pressed():
	revolverbutton.modulate = "00ff00"
	pistolbutton.modulate = "ffffff"
	sidearm = 1


func _on_pistol_button_pressed():
	pistolbutton.modulate = "00ff00"
	revolverbutton.modulate = "ffffff"
	sidearm = 0

func get_settings_from_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	#remember to not use variables inside the query somehow connected with other variables names, it's not working properly
	db.query("SELECT weapons.sidearm, weapons.rifle, weapons.shotgun from user INNER JOIN weapons ON user.id = weapons.id where user.nickname = '" + nick + "';")
	sidearm = db.query_result[0]["sidearm"]
	rifle = db.query_result[0]["rifle"]
	shotgun = db.query_result[0]["shotgun"]
	
func update_db_perks():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "weapons"
	var sidearm_todb = str(sidearm)
	var rifle_todb = str(rifle)
	var shotgun_todb = str(shotgun)
	db.query("SELECT id from user where nickname = '" + nick + "';")
	var user_id_todb = str(db.query_result[0]["id"])
	db.query("UPDATE " + table_name + " SET sidearm = " + sidearm_todb + ", rifle = " + rifle_todb + ", shotgun = " + shotgun_todb + " WHERE id = " + user_id_todb + ";")


func _on_pistol_button_mouse_entered():
	if(sidearm != 0):
		pistolbutton.modulate = "666666"


func _on_pistol_button_mouse_exited():
	if(sidearm != 0):
		pistolbutton.modulate = "ffffff"


func _on_revolver_button_mouse_entered():
	if(sidearm != 1):
		revolverbutton.modulate = "666666"


func _on_revolver_button_mouse_exited():
	if(sidearm != 1):
		revolverbutton.modulate = "ffffff"


func _on_rifle_button_mouse_entered():
	if(rifle != 0):
		riflebutton.modulate = "666666"


func _on_rifle_button_mouse_exited():
	if(rifle != 0):
		riflebutton.modulate = "ffffff"


func _on_ak_button_mouse_entered():
	if(rifle != 1):
		akbutton.modulate = "666666"


func _on_ak_button_mouse_exited():
	if(rifle != 1):
		akbutton.modulate = "ffffff"


func _on_shotgun_button_mouse_entered():
	if(shotgun != 0):
		shotgunbutton.modulate = "666666"


func _on_shotgun_button_mouse_exited():
	if(shotgun != 0):
		shotgunbutton.modulate = "ffffff"


func _on_pump_button_mouse_entered():
	if(shotgun != 1):
		pumpbutton.modulate = "666666"


func _on_pump_button_mouse_exited():
	if(shotgun != 1):
		pumpbutton.modulate = "ffffff"
