extends Node2D

@onready var particles = $CPUParticles2D
@onready var sprite = $"Sprite2D"

@export var et : PackedScene
@export var ec : int

@onready var sound = $"BushSounds"

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(4.0).timeout
	spawn_enemy(et, ec)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy(enemy_type, enemy_count):
	await get_tree().create_timer(2.0).timeout
	while (enemy_count>0):
		var spawned_enemy = enemy_type.instantiate()
		owner.add_child.call_deferred(spawned_enemy)
		spawned_enemy.position = global_position
		particles.emitting = true
		sound.play()
		await get_tree().create_timer(2.0).timeout
		particles.restart()
		enemy_count -= 1


func _on_area_2d_body_entered(body):
	if(body.has_method("get_infected")):
		sprite.modulate = "ffffff4e"
	particles.emitting = true
	sound.play()
	await get_tree().create_timer(2.0).timeout
	particles.restart()


func _on_area_2d_body_exited(body):
	if(body.has_method("get_infected")):
		sprite.modulate = "ffffffff"
	particles.emitting = true
	sound.play()
	await get_tree().create_timer(2.0).timeout
	particles.restart()

