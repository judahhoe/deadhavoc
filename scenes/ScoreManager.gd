extends Node2D

@onready var exp_bar = $"/root/Main/player/HUD/ExpBar"
@onready var exp_label = $"/root/Main/player/HUD/ExpLabel"
@onready var level_label = $"/root/Main/player/HUD/LevelLabel"
@onready var points_label = $"/root/Main/player/HUD/PointsLabel"
@onready var money_label = $"/root/Main/player/HUD/MoneyLabel"
@onready var experience_to_next_level = $"/root/Main/player/HUD/ExpToNextLvlLabel"

var db #database object 
var db_name = "user://data/database" #Path to DB

var experience
var points: int = 0
var exp_to_next_level: int = 300
var level
var money:int = 0
@onready var nick = GlobalVariables.nickname

func _ready():
	get_settings_from_db()
	exp_to_next_level = int(300 * pow(1.5, level - 1))
	exp_bar.max_value = exp_to_next_level
	exp_bar.value = experience
	update_labels()

func add_experience(amount: int):
	experience += amount
	update_db_exp()
	exp_bar.value = experience
	update_labels()
	if experience >= exp_to_next_level:
		level_up()
	print("Liczba punktów doświadczenia: ", experience)

func level_up():
	level += 1
	experience -= exp_to_next_level
	exp_to_next_level = int(300 * pow(1.5, level - 1))
	exp_bar.max_value = exp_to_next_level
	exp_bar.value = experience
	update_db_exp()
	update_labels()
	add_skillpoint()
	print("Osiągnięto poziom: ", level)

func add_skillpoint():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	db.query("UPDATE " + table_name + " SET skillpoints = skillpoints + 1 WHERE nickname = '" + nick + "';")
	db.query("UPDATE " + table_name + " SET level = level + 1 WHERE nickname = '" + nick + "';")

func add_points(amount: int):
	points += amount
	update_db_coins(amount)
	update_labels()
	print("Liczba punktów: ", points)
	
func add_money(amount: int):
	money += amount
	update_db_money(amount)
	update_labels()
	print("Ilość $$$: ", money)

func update_labels():
	exp_label.text = "Exp: %d" % experience
	points_label.text ="Points: %d" % points
	level_label.text = "Level: %d" % level
	money_label.text = "Money: %d" % money
	experience_to_next_level.text = "Next level: %d" % exp_to_next_level

func update_db_exp():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	#var dict : Dictionary = Dictionary()
	#dict["nickname"] = "test3_user"
	#dict["email"] = "test3@wp.pl"
	#dict["password"] = "password"
	#dict["experience"] = 20
	#dict["coins"] = 200.5
	#db.insert_row(table_name, dict)
	db.query("UPDATE " + table_name + " SET experience = " + str(experience) + " WHERE nickname = '" + nick + "';")
	#db.query("UPDATE " + table_name + " set experience = experience + " + exp + ";")

func update_db_coins(amount: int):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	var coins = str(amount)
	db.query("UPDATE " + table_name + " SET coins = coins + " + coins + " WHERE nickname = '" + nick + "';")

func update_db_money(amount: int):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	var money = str(amount)
	db.query("UPDATE " + table_name + " SET money = money + " + money + " WHERE nickname = '" + nick + "';")

func get_settings_from_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	#remember to not use variables inside the query somehow connected with other variables names, it's not working properly
	db.query("SELECT experience, level from user where nickname = '" + nick + "';")
	experience = db.query_result[0]["experience"]
	level = db.query_result[0]["level"]
