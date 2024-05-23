extends CharacterBody2D

@onready var Score_manager = get_node("/root/Main/ScoreManager")
@onready var particle_manager = get_node("/root/Main/ParticleManager")
@onready var main_node = get_node("/root/Main/PickupManager")

@onready var player = $"../%player"
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var medkit = preload("res://scenes/medkit.tscn")
@onready var ammobox = preload("res://scenes/ammobox.tscn")
@onready var blood_pool = preload("res://scenes/blood_pool.tscn")
@onready var enemy = self
@onready var animation_player = $AnimationPlayer

@onready var timer = $"Timer"
@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_cooldown = $AttackCooldown
const BULLET_IMPACT = preload("res://scenes/bullet_impact.tscn")
const BULLET_IMPACT_KILL = preload("res://scenes/bullet_impact2.tscn")
var 	speed 	= 120
var 	health 	= 50
var 	drop
var 	zombie_damage = 10
var 	target
var 	isTargetInRange = false

var exp_value = 100
var points_value = 300
var money_value = 50
#pickups vars
var pickup : Pickup
var launch_speed : float = 100
var launch_time :float = 0.25

func _ready():
	animation_player.play("spawn")

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	sprite.look_at(player.global_position)
	sprite.rotation += 1.57 # 90 in radians
	
func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	timer.wait_time = randf_range(1, 2)
	makepath()

func dropitem(item):
	match item :
		"medkit":
			pickup = medkit.instantiate()
		"ammo":
			pickup = ammobox.instantiate()
	main_node.add_child.call_deferred(pickup)

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
	handle_kill(enemy.global_position)
	queue_free()

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
	Score_manager.add_money(money_value)
	
func handle_kill(position:Vector2):
	var impact = BULLET_IMPACT_KILL.instantiate()
	impact.global_position = position
	impact.emitting = true
	var blood = blood_pool.instantiate()
	blood.global_position = position
	particle_manager.add_child.call_deferred(impact)
	particle_manager.add_child.call_deferred(blood)

func isEnemy():
	pass


func handle_hit():
	if (health > 0):
		health -= 20
		var impact = BULLET_IMPACT.instantiate()
		impact.global_position = position
		impact.emitting = true
		particle_manager.add_child.call_deferred(impact)
	if (health <= 0):
		die();
