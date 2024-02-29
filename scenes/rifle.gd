extends Node2D

class_name Rifle

@export var weapon_type : String
@export var max_ammo : int
@export var ammo : int
@export var mag_size : int
@export var ammo_in_mag : int
@export var Bullet : PackedScene
@export var reload_modifier : int 
@export var recoil : float = 6.0

@onready var end_of_gun = $EndOfGun
@onready var bullet_direction = $BulletDirection
@onready var animation_player = $AnimationPlayer
@onready var shooting_cooldown = $ShootingCooldown
@onready var reload_timer = $ReloadTimer

@onready var ammo_count = $"../HUD/AmmoCount"
@onready var reload_progress = $"../HUD/ReloadProgress"
@onready var bullet_manager = $"../../BulletManager"

@onready var ammo_bar = $"../HUD/Rifle_ammo_bar1"
@onready var ammo_bar2 = $"../HUD/Rifle_ammo_bar2"

signal player_fired_bullet(bullet, direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	reload_progress.visible = false
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	get_node(".").connect("player_fired_bullet",bullet_manager._on_pistol_player_fired_bullet)
	ammo_bar.max_value = 15  
	ammo_bar.value = min(ammo_in_mag, 15)  
	ammo_bar2.max_value = 15  
	ammo_bar2.value = max(0, ammo_in_mag - 15) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	reload_progress.value = (reload_timer.wait_time - reload_timer.time_left) * reload_modifier

func shoot():
	if (shooting_cooldown.is_stopped() && ammo_in_mag >=1 && reload_timer.is_stopped()):
		ammo_in_mag -= 1
		ammo_bar.value = min(ammo_in_mag, 15)  
		ammo_bar2.value = max(0, ammo_in_mag - 15) 
		ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
		var recoil_radians = deg_to_rad(randf_range(-recoil, recoil)) 
		var bullet_instance = Bullet.instantiate()
		bullet_instance.global_position = end_of_gun.global_position
		var target = bullet_direction.global_position
		var direction_to_shoot = bullet_instance.global_position.direction_to(target).normalized()
		direction_to_shoot = direction_to_shoot.rotated(recoil_radians)
		bullet_instance.set_direction(direction_to_shoot)
		emit_signal("player_fired_bullet", bullet_instance)
		animation_player.play("muzzle_flash")
		shooting_cooldown.start()
	else:
		pass
	if (reload_timer.is_stopped() && ammo_in_mag <=0):
		reload()

func reload():
	if(ammo > 0 && reload_timer.is_stopped()):
		reload_timer.start()
		reload_progress.visible = true
		print("reloading")
	else:
		print ("mag is empty or reloading")
	
func cancel_reload():
	reload_timer.stop()
	print("cancel reload")
	
func _on_reload_timer_timeout():
	while (ammo_in_mag < mag_size && ammo > 0):
		ammo_in_mag += 1
		ammo_bar.value = min(ammo_in_mag, 15)  
		ammo_bar2.value = max(0, ammo_in_mag - 15)  
		ammo -= 1
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	reload_progress.visible = false
	print("reloaded")
