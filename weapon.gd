extends Node2D

class_name Weapon

@export var weapon_type : String
@export var max_ammo : int
@export var ammo : int
@export var mag_size : int
@export var ammo_in_mag : int
@export var Bullet : PackedScene
@export var reload_modifier : int

@onready var end_of_gun = $EndOfGun
@onready var bullet_direction = $BulletDirection
@onready var animation_player = $AnimationPlayer
@onready var shooting_cooldown = $ShootingCooldown
@onready var reload_timer = $ReloadTimer

@onready var ammo_count = $"../HUD/AmmoCount"
@onready var reload_progress = $"../HUD/ReloadProgress"
@onready var bullet_manager = $"../../BulletManager"

@onready var shotgun_modifier  : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(1.0, 1.0)
	).normalized()
signal player_fired_bullet(bullet, direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	reload_progress.visible = false
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	get_node(".").connect("player_fired_bullet",bullet_manager._on_pistol_player_fired_bullet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	reload_progress.value = (reload_timer.wait_time - reload_timer.time_left) * reload_modifier

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
		emit_signal("player_fired_bullet", bullet_instance, direction, weapon_type)
		animation_player.play("muzzle_flash")
		shooting_cooldown.start()
		if (weapon_type == "shotgun"):
			var bullet_instance2 = Bullet.instantiate()
			bullet_instance2.global_position = end_of_gun.global_position
			bullet_instance2.set_direction(direction_to_shoot)
			emit_signal("player_fired_bullet", bullet_instance2, direction, weapon_type)
			
			var bullet_instance3 = Bullet.instantiate()
			bullet_instance3.global_position = end_of_gun.global_position
			bullet_instance3.set_direction(direction_to_shoot)
			emit_signal("player_fired_bullet", bullet_instance3, direction+shotgun_modifier, weapon_type)
			
	else:
		pass
	if (reload_timer.is_stopped() && ammo_in_mag <=0):
		reload()

func reload():
	if(ammo > 0):
		reload_timer.start()
		reload_progress.visible = true
		print("reloading")
	else:
		print ("mag is empty")
	
func cancel_reload():
	reload_timer.stop()
	print("cancel reload")
	
func _on_reload_timer_timeout():
	while (ammo_in_mag < mag_size && ammo > 0):
		ammo_in_mag += 1
		ammo -= 1
	ammo_count.text = str(ammo_in_mag) + "/" + str(ammo)
	reload_progress.visible = false
	print("reloaded")
