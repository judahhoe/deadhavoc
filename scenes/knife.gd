extends Node2D

class_name Knife

@export var weapon_type : String

@onready var shooting_cooldown = $ShootingCooldown

@onready var animation_player = $"../../../../../../../AnimationPlayerBody"
#sounds
@onready var attack_sound = $"Attack"

@onready var collider = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func shoot():
	if (shooting_cooldown.is_stopped()):
		shooting_cooldown.start()
		animation_player.play("melee_attack")
	else:
		pass

func play_sound():
	attack_sound.play()


func cancel_reload():
	pass

func reload():
	pass


func _on_area_2d_body_entered(body):
		if (body.has_method("handle_hit")):
			body.handle_hit()

func set_attack(value):
	collider.disabled = !value
