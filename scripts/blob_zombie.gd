extends "enemy.gd"
var start_health = 2000.0 # *2000% of base health
const start_damage = 20 # * 200% of base damage
const start_speed = 10 # 20% of base movement speed
@onready var mob_scene = preload("res://scenes/enemy.tscn")
func _ready():
	health = start_health
	zombie_damage = start_damage
	speed = start_speed

func handle_hit():
	health -= 20
	if (health <= 0):
		die();
	else:
		var health_percent_drop = ((start_health - health) / start_health * 100)
		if health_percent_drop >= 5:
			start_health -= (start_health*0.05)
			spawn_new_base_enemy()

func spawn_new_base_enemy():
	var mob = mob_scene.instantiate()
	print("zombie spawned")
	mob.player = player
	mob.medkit = medkit
	mob.ammobox = ammobox
	var position = enemy.position
	position+= Vector2(10,10)
	mob.global_position = position
	owner.add_child.call_deferred(mob)
