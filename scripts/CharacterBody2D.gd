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

@onready var Pain = $"HUD/BloodOverlay/AnimationPlayer" 

var db #database object 
var db_name = "res://DataStore/database" #Path to DB

var infection_count
var is_infected = false
var healthy = "e40000"
var infected = "696900"

var health = 100
var max_health = 100
var speed = 200  # speed in pixels/sec
var weapon

var rotation_speed = 5
var direction = Vector2(1.0,1.0)


signal player_fired_bulled(bullet, direction)
signal pickup_used()

func _ready():
	health_bar.value = max_health
	health_bar.tint_progress = healthy
	weapon = pistol
	weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)

func _physics_process(delta):
	if (Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down") || Input.is_action_pressed("up")):
		direction = Input.get_vector("left", "right", "up", "down")
	
	#angle between aim direction and walking direction
	var look_angle = calculate_angle(direction, get_global_mouse_position()-position)
	# Print the result
	var speed_modifier = (0.4+(0.6*(180.0-look_angle)/180.0))
	print("Angle between vectors: ", look_angle)
	print("speed modi: ", speed_modifier)

	
	if (Input.is_action_pressed("aim")):
		speed = 30
	else:
		speed = 150
		if (!is_nan(speed_modifier)):
			speed *= speed_modifier
	var v = get_global_mouse_position() - global_position
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
	
func calculate_angle(vectorA, vectorB):
	# Calculate the dot product of the vectors
	var dot_product = vectorA.dot(vectorB)

	# Calculate the magnitude (length) of each vector
	var magnitude_A = vectorA.length()
	var magnitude_B = vectorB.length()

	# Calculate the cosine of the angle using the dot product and magnitudes
	var cos_angle = dot_product / (magnitude_A * magnitude_B)

	# Use the arccosine function to get the angle in radians
	var angle_radians = acos(cos_angle)

	# Convert radians to degrees
	var angle_degrees = rad_to_deg(angle_radians)

	return angle_degrees

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
	var infection_chance = randi_range(1,100)
	if(infection_chance>=1 && infection_chance <=20):
		get_infected()
	health -= damage
	Pain.play("pain")
	if (health >= 0):
		health_bar.value = health
	else:
		health_bar.value = 0
	if (health <= 0):
		die()
		
		
func handle_hit(damage):
	health -= damage
	Pain.play("pain")
	if (health >= 0):
		health_bar.value = health
	else:
		health_bar.value = 0
	if (health <= 0):
		die()
		
func get_infected():
	if (!is_infected):
		health_bar.tint_progress = infected
		is_infected = true
		infection_count = 10
		while infection_count>0:
			await get_tree().create_timer(1).timeout
			infection_count -= 1
			health -= 1
			health_bar.value = health
		is_infected = false
		health_bar.tint_progress = healthy
	else:
		infection_count += 2

func die():
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
