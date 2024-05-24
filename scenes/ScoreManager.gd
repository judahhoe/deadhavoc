extends Node2D

@onready var exp_bar = $"/root/Main/player/HUD/ExpBar"
@onready var exp_label = $"/root/Main/player/HUD/ExpLabel"
@onready var level_label = $"/root/Main/player/HUD/LevelLabel"
@onready var points_label = $"/root/Main/player/HUD/PointsLabel"
@onready var money_label = $"/root/Main/player/HUD/MoneyLabel"
@onready var experience_to_next_level = $"/root/Main/player/HUD/ExpToNextLvlLabel"

var db #database object 
var db_name = "user://data/database" #Path to DB

var experience: int = 0
var points: int = 0
var exp_to_next_level: int = 300
var level: int = 1
var money:int = 0
@onready var nick = GlobalVariables.nickname

func _ready():
	exp_bar.max_value = exp_to_next_level
	exp_bar.value = experience
	update_labels()

func add_experience(amount: int):
	experience += amount
	update_db_exp(amount)
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
	update_labels()
	print("Osiągnięto poziom: ", level)

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

func update_db_exp(amount: int):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	var exp = str(amount)
	#var dict : Dictionary = Dictionary()
	#dict["nickname"] = "test3_user"
	#dict["email"] = "test3@wp.pl"
	#dict["password"] = "password"
	#dict["experience"] = 20
	#dict["coins"] = 200.5
	#db.insert_row(table_name, dict)
	db.query("UPDATE " + table_name + " SET experience = experience + " + exp + " WHERE nickname = '" + nick + "';")
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
