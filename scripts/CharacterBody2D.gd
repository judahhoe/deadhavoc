extends CharacterBody2D

@export var crosshair : Sprite2D

#@onready var knife = $"knife"
@onready var pistol = $"pistol"
@onready var shotgun = $"shotgun"
@onready var rifle = $"rifle"

@onready var health_bar = $"HUD/HealthBar"

@onready var exp_label = $"HUD/EXPLabel"
@onready var lvl_label = $"HUD/LVLLabel"
@onready var exp_to_next_level_label = $"HUD/ExpToNextLevelLabel"


var health = 100
var max_health = 100
var speed = 200  # speed in pixels/sec
var weapon

var rotation_speed = 5
var direction = Vector2(1.0,1.0)

var experience = 0
var exp_to_next_level = 300
var level = 1

signal player_fired_bulled(bullet, direction)
signal pickup_used()

func _ready():
	health_bar.value = max_health
	weapon = pistol
	weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)
	for enemy in get_node("/root/Main").get_children():
		enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
	update_labels()
	
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
	
func _unhandled_input(event):
	if(event.is_action_pressed("shoot")):
		weapon.shoot()
	if(event.is_action_pressed("reload")):
		if(weapon.ammo_in_mag<weapon.mag_size):
			weapon.reload()
		else:
			print("fully reloaded")
	if(event.is_action_pressed("weapon_pistol")):
		change_weapon(pistol)
	if(event.is_action_pressed("weapon_shotgun")):
		change_weapon(shotgun)
	if(event.is_action_pressed("weapon_rifle")):
		change_weapon(rifle)


func change_weapon(weapon_type):
	weapon.cancel_reload()
	weapon.visible = false
	weapon = weapon_type
	weapon.visible = true
	weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)
	

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
		if (weapon.ammo<weapon.max_ammo):
			weapon.ammo += 10
			if (weapon.ammo > weapon.max_ammo):
				weapon.ammo = weapon.max_ammo
			print("picked up ammo")
			weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)
			pickup_obj.queue_free()


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
	
func gain_exp(amount: int):
	experience += amount
	print("Otrzymamano exp")
	if experience >= exp_to_next_level:
		level_up()


func level_up():
	level += 1
	experience -= exp_to_next_level
	exp_to_next_level *= 2  # Możesz dostosować wzór wzrostu doświadczenia
	print("Osiągnięto poziom: ", level)
	
	
func _on_enemy_died(exp_value, position):
	gain_exp(exp_value)
	update_labels()


func update_labels():
	exp_label.text = "EXP: %d" % experience
	lvl_label.text = "LVL: %d" % level #
	exp_to_next_level_label.text = "EXP to next level: %d" % exp_to_next_level #
