extends CharacterBody2D

@onready var Score_manager = get_node("/root/Main/ScoreManager")

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var medkit: PackedScene
@export var ammobox: PackedScene
@export var enemy: Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_cooldown = $AttackCooldown
@onready var mob_scene = preload("res://scenes/enemy.tscn")

var 	speed 	= 10 # 20% of base movement speed
var 	start_health = 2000.0
var 	health 	= 2000.0  # *2000% of base health
var 	drop
var 	zombie_damage = 20 # * 200% of base damage
var 	target
var 	isTargetInRange = false

var exp_value = 250
var points_value = 800

#pickups vars
var pickup : Pickup
var launch_speed : float = 100
var launch_time :float = 0.25


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
			pickup = medkit.instantiate()
		"ammo":
			pickup = ammobox.instantiate()
	
	get_parent().add_child.call_deferred(pickup)
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

func add_score():
	Score_manager.add_experience(exp_value)
	Score_manager.add_points(points_value)
