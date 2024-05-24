extends Control
@export var skill_points : int = 10
var max_level : int = 3
var ammo_level = 0
var health_level = 0
var recoil_level = 0
var reload_level = 0
var speed_level = 0

var db #database object 
var db_name = "user://data/database" #Path to DB
var nick = GlobalVariables.nickname

@onready var skill_points_label = $"SkillPoints"

@onready var ammo_button = $"SkillAmmo"
@onready var ammo_button_label = $"SkillAmmo/SkillLevel"
@onready var health_button = $"SkillHealth"
@onready var health_button_label = $"SkillHealth/SkillLevel"
@onready var recoil_button = $"SkillRecoil"
@onready var recoil_button_label = $"SkillRecoil/SkillLevel"
@onready var reload_button = $"SkillReload"
@onready var reload_button_label = $"SkillReload/SkillLevel"
@onready var speed_button = $"SkillSpeed"
@onready var speed_button_label = $"SkillSpeed/SkillLevel"

# Called when the node enters the scene tree for the first time.
func _ready():
	#DB read and set values
	get_settings_from_db()
	#temp values
	skill_points_label.text = "Skill points: " + str(skill_points)
	ammo_button_label.text = str(ammo_level) + "/" + str(max_level)
	health_button_label.text = str(health_level) + "/" + str(max_level)
	recoil_button_label.text = str(recoil_level) + "/" + str(max_level)
	reload_button_label.text = str(reload_level) + "/" + str(max_level)
	speed_button_label.text = str(speed_level) + "/" + str(max_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_skill_ammo_pressed():
	if (skill_points > 0):
		if(ammo_level < max_level):
			ammo_level += 1
			ammo_button.self_modulate = Color(0.4, 1, 0.4)
			ammo_button_label.text = str(ammo_level) + "/" + str(max_level)
			update_skill_points()


func _on_skill_health_pressed():
	if (skill_points > 0):
		if(health_level < max_level):
			health_level += 1
			health_button.self_modulate = Color(0.4, 1, 0.4)
			health_button_label.text = str(health_level) + "/" + str(max_level)
			update_skill_points()


func _on_skill_recoil_pressed():
	if (skill_points > 0):
		if(recoil_level < max_level):
			recoil_level += 1
			recoil_button.self_modulate = Color(0.4, 1, 0.4)
			recoil_button_label.text = str(recoil_level) + "/" + str(max_level)
			update_skill_points()


func _on_skill_reload_pressed():
	if (skill_points > 0):
		if(reload_level < max_level):
			reload_level += 1
			reload_button.self_modulate = Color(0.4, 1, 0.4)
			reload_button_label.text = str(reload_level) + "/" + str(max_level)
			update_skill_points()


func _on_skill_speed_pressed():
	if (skill_points > 0):
		if(speed_level < max_level):
			speed_level += 1
			speed_button.self_modulate = Color(0.4, 1, 0.4)
			speed_button_label.text = str(speed_level) + "/" + str(max_level)
			update_skill_points()

func update_skill_points():
	skill_points -= 1
	skill_points_label.text = "Skill points: " + str(skill_points)


func _on_apply_button_pressed():
	update_db_perks()

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_main.tscn")
func get_settings_from_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	#remember to not use variables inside the query somehow connected with other variables names, it's not working properly
	db.query("SELECT perks.player_health, perks.movement_speed, perks.weapons_recoil, perks.max_ammo, perks.reload_speed from user INNER JOIN perks ON user.id = perks.id where user.nickname = '" + nick + "';")
	health_level = db.query_result[0]["player_health"]
	speed_level = db.query_result[0]["movement_speed"]
	recoil_level = db.query_result[0]["weapons_recoil"]
	ammo_level = db.query_result[0]["max_ammo"]
	reload_level = db.query_result[0]["reload_speed"]
	skill_points = skill_points - (health_level+speed_level+recoil_level+ammo_level+reload_level)
	skill_points_label.text = "Skill points: " + str(skill_points)
	if (speed_level > 0):
		speed_button.self_modulate = Color(0.4, 1, 0.4)
		speed_button_label.text = str(speed_level) + "/" + str(max_level)
	if (reload_level > 0):
		reload_button.self_modulate = Color(0.4, 1, 0.4)
		reload_button_label.text = str(reload_level) + "/" + str(max_level)
	if (recoil_level > 0):
		recoil_button.self_modulate = Color(0.4, 1, 0.4)
		recoil_button_label.text = str(recoil_level) + "/" + str(max_level)
	if (health_level > 0):
		health_button.self_modulate = Color(0.4, 1, 0.4)
		health_button_label.text = str(health_level) + "/" + str(max_level)
	if (ammo_level > 0):
		ammo_button.self_modulate = Color(0.4, 1, 0.4)
		ammo_button_label.text = str(ammo_level) + "/" + str(max_level)
	
func update_db_perks():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "perks"
	var health_level_todb = str(health_level)
	var speed_level_todb = str(speed_level)
	var recoil_level_todb = str(recoil_level)
	var ammo_level_todb = str(ammo_level)
	var reload_level_todb = str(reload_level)
	db.query("SELECT id from user where nickname = '" + nick + "';")
	var user_id_todb = str(db.query_result[0]["id"])
	db.query("UPDATE " + table_name + " SET player_health = " + health_level_todb + ", movement_speed = " + speed_level_todb + ", weapons_recoil = " + recoil_level_todb + ", max_ammo = " + ammo_level_todb + ", reload_speed = " + reload_level_todb + " WHERE id = " + user_id_todb + ";")

