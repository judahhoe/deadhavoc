extends Node2D

class_name Rifle

@export var weapon_type : String
var max_ammo : int = 120
var ammo : int = 60
@export var mag_size : int
@export var ammo_in_mag : int
@export var Bullet : PackedScene
@export var reload_modifier : int 
@export var recoil : float = 6.0

@onready var muzzle_player = $AnimationPlayer
@onready var casing_emitter = preload("res://scenes/rifle_casing_particles.tscn")
@onready var end_of_gun = $EndOfGun
@onready var bullet_direction = $BulletDirection
@onready var animation_player = $"../../../../../../../AnimationPlayerBody"
@onready var shooting_cooldown = $ShootingCooldown
@onready var reload_timer = $ReloadTimer
@onready var gunshot_sound = $Gunshot
@onready var reload_sound = $Reload

@onready var ammo_count = $"../../../../../../../HUD/AmmoCount"
@onready var reload_progress = $"../../../../../../../HUD/ReloadProgress"
@onready var bullet_manager = $"../../../../../../../../BulletManager"
@onready var casing_eject = $"CasingEject"

@onready var particle_manager = get_node("/root/Main/ParticleManager")

@onready var ammo_bar_bottom = $"../../../../../../../HUD/Rifle_ammo_bar1"
@onready var ammo_bar_top = $"../../../../../../../HUD/Rifle_ammo_bar2"

signal player_fired_bullet(bullet, direction)
var max_level : int = 3
var ammo_level = 0
var health_level = 0
var recoil_level = 0
var reload_level = 0
var speed_level = 0

var db #database object 
var db_name = "res://DataStore/database" #Path to DB
var nick = "test_user"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_settings_from_db()
	max_ammo += ammo_level * 20
	ammo += ammo_level * 20
	recoil -= recoil_level * 1.2
	reload_timer.wait_time -= reload_level * 0.2
	
	reload_progress.visible = false
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	get_node(".").connect("player_fired_bullet",bullet_manager._on_pistol_player_fired_bullet)
	if (ammo_in_mag >= mag_size/2):
		ammo_bar_top.value = ammo_in_mag-(mag_size/2)
		ammo_bar_bottom.value = mag_size/2
	else :
		ammo_bar_bottom.value = ammo_in_mag


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	reload_progress.value = (reload_timer.wait_time - reload_timer.time_left) * reload_modifier

func shoot():
	if (shooting_cooldown.is_stopped() && ammo_in_mag >=1 && reload_timer.is_stopped()):
		ammo_in_mag -= 1
		if (ammo_in_mag >= mag_size/2):
			ammo_bar_top.value -= 1
		else :
			ammo_bar_bottom.value -= 1
		ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
		var recoil_radians = deg_to_rad(randf_range(-recoil, recoil)) 
		var bullet_instance = Bullet.instantiate()
		bullet_instance.global_position = end_of_gun.global_position
		var target = bullet_direction.global_position
		var direction_to_shoot = bullet_instance.global_position.direction_to(target).normalized()
		direction_to_shoot = direction_to_shoot.rotated(recoil_radians)
		bullet_instance.set_direction(direction_to_shoot)
		emit_signal("player_fired_bullet", bullet_instance)
		gunshot_sound.play()
		muzzle_player.play("muzzle_flash")
		emitt_casing()
		shooting_cooldown.start()
	else:
		pass
	if (reload_timer.is_stopped() && ammo_in_mag <=0):
		reload()

func emitt_casing():
	var casing = casing_emitter.instantiate()
	casing.global_position = casing_eject.global_position 
	particle_manager.add_child(casing)
	casing.emitting = true

func reload():
	if(ammo > 0 && reload_timer.is_stopped()):
		reload_timer.start()
		reload_sound.play()
		reload_progress.visible = true
		print("reloading")
		animation_player.play("rifle_reload")
	else:
		print ("mag is empty or reloading")
	
func cancel_reload():
	reload_timer.stop()
	print("cancel reload")
	
func _on_reload_timer_timeout():
	while (ammo_in_mag < mag_size && ammo > 0):
		ammo_in_mag += 1
		if (ammo_in_mag >= mag_size/2):
			ammo_bar_top.value = ammo_in_mag-(mag_size/2)
			ammo_bar_bottom.value = mag_size/2
		else :
			ammo_bar_bottom.value = ammo_in_mag
		ammo -= 1
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	reload_progress.visible = false
	print("reloaded")

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
