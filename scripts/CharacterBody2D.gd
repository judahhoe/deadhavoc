extends CharacterBody2D

@onready var knife = $"Skeleton2D/hip/chest/arm_right/forearm_right/hand_right/knife"
@onready var pistol = $Skeleton2D/hip/chest/arm_right/forearm_right/hand_right/pistol
@onready var shotgun = $"Skeleton2D/hip/chest/arm_right/forearm_right/hand_right/shotgun"
@onready var rifle = $"Skeleton2D/hip/chest/arm_right/forearm_right/hand_right/rifle"

var sidearm_db = 0
var rifle_db = 0
var shotgun_db = 0

@onready var health_bar = $"HUD/HealthBar"

@onready var ammo_counter = $HUD/AmmoCount
@onready var pistol_ammo_bar = $"HUD/Pistol_ammo_bar"
@onready var rifle_ammo_bar_bottom = $"HUD/Rifle_ammo_bar1"
@onready var rifle_ammo_bar_top = $"HUD/Rifle_ammo_bar2"
@onready var shotgun_ammo_bar = $"HUD/Shotgun_ammo_bar"
@onready var revolver_ammo_bar = $"HUD/Revolver_ammo_bar"
@onready var pump_ammo_bar = $"HUD/Pump_ammo_bar"
@onready var knife_hud = $"HUD/Knife"
@onready var pistol_hud = $"HUD/Pistol"
@onready var rifle_hud = $"HUD/Rifle"
@onready var shotgun_hud = $"HUD/Shotgun"
@onready var revolver_hud = $"HUD/Revolver"
@onready var ak_hud = $"HUD/Ak"
@onready var pump_hud = $"HUD/Pump"
@onready var Pain = $"HUD/BloodOverlay/AnimationPlayer" 
const BULLET_IMPACT_KILL = preload("res://scenes/bullet_impact2.tscn")
var max_level : int = 3
var ammo_level = 0
var health_level = 0
var recoil_level = 0
var reload_level = 0
var speed_level = 0

var canReload = true

var db #database object 
var db_name = "user://data/database" #Path to DB
@onready var nick = GlobalVariables.nickname

@onready var particle_manager = get_node("/root/Main/ParticleManager")

@onready var footsteps_sound = $"FootstepsSounds"
@onready var animation_player_legs = $"AnimationPlayerLegs"
@onready var animation_player_body = $"AnimationPlayerBody"

@onready var tilemap = get_node("/root/Main/Map/GroundAndWalls")
@onready var grass_step = preload("res://sfx/trawa krok1 cut.mp3")
@onready var wood_step = preload("res://sfx/drewno krok 1 cut.mp3")
@onready var cement_step = preload("res://sfx/beton krok 1 cut.mp3")
@onready var step_position = $"StepChecker"


var tile

var infection_count
var is_infected = false
var healthy = "f2f2f2"
var infected = "696900"

var isSprinting = false
var health = 100
var max_health = 100
var speed = 200  # speed in pixels/sec
var weapon

var rotation_speed = 5
var direction = Vector2(1.0,1.0)

var step = false

signal player_fired_bulled(bullet, direction)
signal pickup_used()

@onready var global_variables = get_node("/root/GlobalVariables")

func _ready():
	get_settings_from_db()
	max_health += health_level * 20
	health = max_health
	speed += speed_level * 10
	
	#set weapons according to db
	if(sidearm_db == 0):
		pistol.mag_size = 15
		pistol.ammo_in_mag = 15
		pistol.reload_modifier = 0
		pistol.recoil = 6
	if(sidearm_db == 1):
		pistol.mag_size = 6
		pistol.ammo_in_mag = 6
		pistol.reload_modifier = 0
		pistol.recoil = 8
	if(rifle_db == 0):
		rifle.mag_size = 30
		rifle.ammo_in_mag = 30
		rifle.reload_modifier = 0
		rifle.recoil = 10
	if(rifle_db == 1):
		rifle.mag_size = 30
		rifle.ammo_in_mag = 30
		rifle.reload_modifier = 0
		rifle.recoil = 14
	if(shotgun_db == 0):
		shotgun.mag_size = 7
		shotgun.ammo_in_mag = 7
		shotgun.reload_modifier = 15
		shotgun.recoil = 20
		shotgun.max_pellets = 6
	if(shotgun_db == 1):
		shotgun.mag_size = 5
		shotgun.ammo_in_mag = 5
		shotgun.reload_modifier = 15
		shotgun.recoil = 14
		shotgun.max_pellets = 5
	
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_bar.tint_progress = healthy
	weapon = pistol
	weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)
	update_weapon_hud(weapon, true)
	change_weapon(pistol)
	animation_player_body.play("pistol_aim")

func switch_reload_state():
	if(canReload):
		canReload = false
	if(!canReload):
		canReload = true

func _physics_process(delta):
	if(Input.is_action_pressed("shoot")):
		weapon.shoot()
	if (Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down") || Input.is_action_pressed("up")):
		direction = Input.get_vector("left", "right", "up", "down")
		if(step):
			animation_player_legs.play("walking_animation_0")
		else:
			animation_player_legs.play("walking_animation_1")
	
	#angle between aim direction and walking direction
	var look_angle = calculate_angle(direction, get_global_mouse_position()-position)
	# Print the result
	var speed_modifier = (0.4+(0.6*(180.0-look_angle)/180.0))
	
	#tilemap.local_to_map(step_position.global_position - Vector2(80,-80)) DON'T EVER DELETE THIS
	tile = tilemap.get_cell_atlas_coords(0, tilemap.local_to_map(step_position.global_position - Vector2(80,-80))) 
	
	if (Input.is_action_pressed("sprint")):
		speed = 200
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
	if(event.is_action_pressed("reload")):
		if(weapon != knife):
			if(canReload):
				if(weapon.ammo_in_mag<weapon.mag_size):
					weapon.reload()
			else:
				print("fully reloaded")
	if(event.is_action_pressed("weapon_knife")):
		change_weapon(knife)
		animation_player_body.play("melee_idle")
	if(event.is_action_pressed("weapon_pistol")):
		change_weapon(pistol)
		animation_player_body.play("pistol_aim")
	if(event.is_action_pressed("weapon_shotgun")):
		change_weapon(shotgun)
		animation_player_body.play("shotgun_aim")
	if(event.is_action_pressed("weapon_rifle")):
		change_weapon(rifle)
		animation_player_body.play("rifle_aim")

func change_weapon(weapon_type):
	weapon.cancel_reload()
	weapon.visible = false
	weapon = weapon_type
	weapon.visible = true
	if(weapon_type != knife):
		weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)
	update_weapon_hud(weapon, true)
	
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
		if(weapon != knife):
			if (weapon.ammo<weapon.max_ammo):
				weapon.ammo += 10
				if (weapon.ammo > weapon.max_ammo):
					weapon.ammo = weapon.max_ammo
				print("picked up ammo")
				weapon.ammo_count.text = str(weapon.ammo_in_mag) + "/" + str(weapon.ammo)
				pickup_obj.queue_free()
	if (pickup == "suitcase"):
		global_variables.hasSuitcase = true
		pickup_obj.queue_free()
	if (pickup == "gascan"):
		global_variables.hasGascan = true
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
	handle_kill(global_position)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func update_weapon_hud(weapon, visible = false):
	knife_hud.visible = false
	pistol_hud.visible = false
	revolver_hud.visible = false
	rifle_hud.visible = false
	ak_hud.visible = false
	shotgun_hud.visible = false
	pump_hud.visible = false
	pistol_ammo_bar.visible = false
	revolver_ammo_bar.visible = false
	rifle_ammo_bar_top.visible = false
	rifle_ammo_bar_bottom.visible = false
	shotgun_ammo_bar.visible = false
	pump_ammo_bar.visible = false
	ammo_counter.visible = true
	
	if weapon is Knife and visible:
		knife_hud.visible = true
		ammo_counter.visible = false
	elif weapon is Pistol and visible:
		if(sidearm_db == 0):
			pistol_hud.visible = true
			pistol_ammo_bar.visible = true
		if(sidearm_db == 1):
			revolver_hud.visible = true
			revolver_ammo_bar.visible = true
	elif weapon is Rifle and visible:
		if(rifle_db == 0):
			rifle_hud.visible = true
		if(rifle_db == 1):
			ak_hud.visible = true
		rifle_ammo_bar_top.visible = true
		rifle_ammo_bar_bottom.visible = true
	elif weapon is Shotgun and visible:
		if(shotgun_db == 0):
			shotgun_hud.visible = true
			shotgun_ammo_bar.visible = true
		if(shotgun_db == 1):
			pump_hud.visible = true
			pump_ammo_bar.visible = true
		
func handle_kill(position:Vector2):
	var impact = BULLET_IMPACT_KILL.instantiate()
	particle_manager.add_child(impact)
	impact.global_position = position
	impact.emitting = true

func play_footsteps():
	if(tile == Vector2i(0,0) || tile == Vector2i(0,1) || tile == Vector2i(0,2)):
		footsteps_sound.stream = grass_step
	if(tile == Vector2i(1,0) || tile == Vector2i(4,0) || tile == Vector2i(7,0)):
		footsteps_sound.stream = cement_step
	if(tile == Vector2i(5,0)):
		footsteps_sound.stream = wood_step
	
	footsteps_sound.pitch_scale = randf_range(.8, 1.2)
	footsteps_sound.play()
func get_settings_from_db():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	#remember to not use variables inside the query somehow connected with other variables names, it's not working properly
	db.query("SELECT perks.player_health, perks.movement_speed, perks.weapons_recoil, perks.max_ammo, perks.reload_speed from user INNER JOIN perks ON user.id = perks.id where user.nickname = '" + nick + "';")
	health_level = db.query_result[0]["player_health"]
	speed_level = db.query_result[0]["movement_speed"]
	recoil_level = db.query_result[0]["weapons_recoil"]
	ammo_level = db.query_result[0]["max_ammo"]
	reload_level = db.query_result[0]["reload_speed"]
	db.query("SELECT weapons.sidearm, weapons.rifle, weapons.shotgun from user INNER JOIN weapons ON user.id = weapons.id where user.nickname = '" + nick + "';")
	sidearm_db = db.query_result[0]["sidearm"]
	rifle_db = db.query_result[0]["rifle"]
	shotgun_db = db.query_result[0]["shotgun"]

func set_step():
	if(step):
		step = false
	else:
		step = true
