extends CharacterBody2D

@onready var Score_manager = get_node("/root/Main/ScoreManager")

@onready var player = $"../%player"
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var medkit = preload("res://scenes/medkit.tscn").instantiate()
@onready var ammobox = preload("res://scenes/ammobox.tscn").instantiate()
@onready var enemy = self

@export var Bullet : PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_cooldown = $AttackCooldown
var 	speed 	= 30
var 	health 	= 200
var 	drop
var 	zombie_damage = 20
var 	target
var 	isTargetInRange = false

var exp_value = 300
var points_value = 1000
var money_value = 100

#pickups vars
var pickup : Pickup
var launch_speed : float = 100
var launch_time :float = 0.25
var dodgeChance: float = 0.5

var timer = 0
var czas_miedzy_akcjami = 1.0  # czas w sekundach między kolejnymi akcjami
var test = 0
func _process(delta):
	timer += delta  # dodaj czas od ostatniego wywołania funkcji

	if timer >= czas_miedzy_akcjami:
		throw()
		print("zombie throws stone")
		timer = 0  # zresetuj timer po wykonaniu akcji
	
		if (test ==0):
			enemy.position=player.global_position
			test = 1
			



func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	sprite.look_at(player.global_position)
	sprite.rotation += 1.57 # 90 in radians
	
func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()

func dropitem(item):
	match item :
		"medkit":
			pickup = medkit
		"ammo":
			pickup = ammobox
	if (owner != null):
		owner.add_child.call_deferred(pickup)
	
	pickup.position = enemy.global_position
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	pickup.launch(direction * launch_speed, launch_time)

func die():
	drop = randi_range(1,100)
	if(drop>=1 && drop <=20):
		dropitem("medkit")
	if(drop>20 && drop <=40):
		dropitem("ammo")
	add_score()
	queue_free()


func handle_hit():
	if (health > 0):
		health -= 20
		print("bullet hit")
	if (health <= 0):
		die();


func _on_attack_cooldown_timeout():
	deal_damage(target, zombie_damage)
	
func deal_damage(target,damage):
	if (isTargetInRange):
		target.take_damage(damage)
	else:
		print("target escaped")

func _on_damage_area_body_entered(body):
	if (body.has_method("take_damage")):
		isTargetInRange = true
		print("player entered")
		attack_cooldown.start()
		target = body


func _on_damage_area_body_exited(body):
	if (body.has_method("take_damage")):
		isTargetInRange = false
		attack_cooldown.stop()

func throw():
	var bullet_instance = Bullet.instantiate()
	var bulletPosition: Vector2 = Vector2(20, 0).rotated(enemy.rotation)
	bullet_instance.global_position = enemy.global_position+bulletPosition
	var target =  player.global_position
	var direction_to_shoot = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_shoot)
	owner.add_child.call_deferred(bullet_instance)

func add_score():
	Score_manager.add_experience(exp_value)
	Score_manager.add_points(points_value)
	Score_manager.add_money(money_value)

