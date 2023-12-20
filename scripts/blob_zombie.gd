extends "enemy.gd"
const start_health = 2000 # *2000% of base health
const start_damage = 20 # * 200% of base damage
const start_speed = 10 # 20% of base movement speed
@onready var mob_scene = preload("res://scenes/enemy.tscn")
func _ready():
	health = start_health
	zombie_damage = start_damage
	speed = start_speed

func handle_hit():
	health -= 20
	var text = "zombie health " + str(health) 
	print(text)
	if (health <= 0):
		die();
	else:
		spawn_new_base_enemy(player.global_position)


func spawn_new_base_enemy(position: Vector2):
	var mob = mob_scene.instantiate()
	print("zombie spawned")
	mob.player = player
	mob.medkit = medkit
	mob.ammobox = ammobox
	mob.global_position = position

	add_child(mob)
	

