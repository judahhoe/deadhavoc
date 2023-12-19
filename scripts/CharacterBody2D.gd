extends CharacterBody2D

@export var crosshair : Sprite2D
@export var Bullet : PackedScene

@onready var end_of_gun = $EndOfGun
@onready var bullet_direction = $BulletDirection
@onready var animation_player = $AnimationPlayer
@onready var shooting_cooldown = $ShootingCooldown
@onready var reload_timer = $ReloadTimer

@onready var ammo_count = $"CanvasLayer/AmmoCount"
@onready var health_bar = $"CanvasLayer/HealthBar"
@onready var reload_progress = $"CanvasLayer/ReloadProgress"

var health = 100
var max_health = 100
var speed = 150  # speed in pixels/sec
var max_ammo = 20
var ammo = 20
var mag_size = 15
var ammo_in_mag = 15

var rotation_speed = 5
var direction = Vector2(1.0,1.0)

signal player_fired_bulled(bullet, direction)
signal pickup_used()

func _ready():
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	health_bar.value = max_health
	
func _physics_process(delta):
	if (Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down") || Input.is_action_pressed("up")):
		direction = Input.get_vector("left", "right", "up", "down")
	var movement_direction := Vector2.ZERO
	#player rotation
	if (Input.is_action_pressed("aim")):
		speed = 50
		var v = get_global_mouse_position() - global_position
		var angle = v.angle()
		var r = global_rotation
		var angle_delta = rotation_speed * delta
		angle = lerp_angle(r, angle, 1.0)
		angle = clamp(angle, r-angle_delta, r+angle_delta)
		global_rotation = angle
	else:
		speed = 150
		var v = direction
		var angle = v.angle()
		var r = global_rotation
		var angle_delta = rotation_speed * delta
		angle = lerp_angle(r, angle, 1.0)
		angle = clamp(angle, r-angle_delta, r+angle_delta)
		global_rotation = angle
	if (Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down") || Input.is_action_pressed("up")):
		velocity = (direction * speed)
		move_and_slide()

	reload_progress.value = (reload_timer.wait_time - reload_timer.time_left) * 50
	
func _unhandled_input(event):
	if(event.is_action_pressed("shoot")):
		shoot()
	if(event.is_action_pressed("reload")):
		if(ammo_in_mag<mag_size):
			reload()
		else:
			print("fully reloaded")

func handle_pickup(pickup_obj, pickup):
	print(pickup_obj)
	if (pickup == "medkit"):
		if (health<max_health):
			health += 50
			if (health > max_health):
				health = max_health
			print("picked up medkit")
			pickup_obj.queue_free()
			health_bar.value = health
	if (pickup == "ammobox"):
		if (ammo<max_ammo):
			ammo += 10
			if (ammo > max_ammo):
				ammo = max_ammo
			print("picked up ammo")
			ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
			pickup_obj.queue_free()

func shoot():
	if (shooting_cooldown.is_stopped() && ammo_in_mag >=1):
		ammo_in_mag -= 1
		ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
		var bullet_instance = Bullet.instantiate()
		bullet_instance.global_position = end_of_gun.global_position
		var target = bullet_direction.global_position
		var direction = bullet_direction.global_position - end_of_gun.global_position
		var direction_to_shoot = bullet_instance.global_position.direction_to(target).normalized()
		bullet_instance.set_direction(direction_to_shoot)
		emit_signal("player_fired_bulled", bullet_instance, direction)
		animation_player.play("muzzle_flash")
		shooting_cooldown.start()
	else:
		pass
	if (reload_timer.is_stopped() && ammo_in_mag <=0):
		reload()

func reload():
	reload_timer.start()
	reload_progress.visible = true
	print("reloading")

func take_damage(damage):
	health -= damage
	if (health >= 0):
		health_bar.value = health
	else:
		health_bar.value = 0
	if (health <= 0):
		die()

func die():
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func _on_reload_timer_timeout():
	while (ammo_in_mag < mag_size && ammo > 0):
		ammo_in_mag += 1
		ammo -= 1
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	reload_progress.visible = false
	print("reloaded")
