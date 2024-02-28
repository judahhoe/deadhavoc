extends Node2D

var db #database object 
var db_name = "res://DataStore/database" #Path to DB

var experience: int = 0
var points: int = 0
var exp_to_next_level: int = 300
var level: int = 1

func _ready():
	pass

func add_experience(amount: int):
	experience += amount
	if experience >= exp_to_next_level:
		level_up()
	print("Liczba punktów doświadczenia: ", experience)

func level_up():
	level += 1
	experience -= exp_to_next_level
	exp_to_next_level *= 2
	print("Osiągnięto poziom: ", level)

func add_points(amount: int):
	points += amount
	print("Liczba punktów: ", points)

func update_db_exp(amount: int):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var table_name = "user"
	var nick = "test_user"
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
