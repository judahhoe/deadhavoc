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
@onready var animation_player_legs = $AnimationPlayerLegs

@onready var stepsSound = $StepsSound
@onready var throwSound = $ThrowSound

@onready var stone_spawn_point = $gfx/Skeleton2D/hip/chest/right_arm/right_forearm/right_hand/StoneMarker
@onready var stone = preload("res://scenes/stone.tscn")
@onready var stone_hole = preload("res://scenes/stone_hole.tscn")
@onready var timer = $"Timer"
@onready var sprite = $gfx
@onready var attack_cooldown = $AttackCooldown
const BULLET_IMPACT = preload("res://scenes/bullet_impact.tscn")
const BULLET_IMPACT_KILL = preload("res://scenes/bullet_impact2.tscn")
var 	speed 	= 30
var 	health 	= 700
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
	animation_player_legs.play("walk")

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

func play_footsteps():
	stepsSound.pitch_scale = randf_range(.8, 1.2)
	stepsSound.play()

func handle_hit():
	if (health > 0):
		health -= 20
		var impact = BULLET_IMPACT.instantiate()
		impact.global_position = position
		impact.emitting = true
		particle_manager.add_child.call_deferred(impact)
	if (health <= 0):
		die();


func _on_attack_cooldown_timeout():
	animation_player.play("throw_stone")
	
func play_throwing_sound():
	throwSound.play()
	
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

func add_hole():
	var hole = stone_hole.instantiate()
	hole.global_position = stone_spawn_point.global_position
	main_node.add_child.call_deferred(hole)

func throw():
	var bullet_instance = stone.instantiate()
	var bulletPosition: Vector2 = Vector2(20, 0).rotated(enemy.rotation)
	bullet_instance.global_position = stone_spawn_point.global_position
	var target =  player.global_position
	var direction_to_shoot = bullet_instance.global_position.direction_to(target).normalized() * 0.5
	bullet_instance.set_direction(direction_to_shoot)
	owner.add_child.call_deferred(bullet_instance)
