extends Node2D

@onready var particles = $CPUParticles2D
@onready var sprite = $"Sprite2D"

@onready var enemyTypeBasic = preload("res://scenes/enemy.tscn")

@onready var sound = $"BushSounds"

var spawnedEnemies = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
		await get_tree().create_timer(randf_range(0.5,2.5)).timeout
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


func _on_detect_player_body_entered(body):
	if(body.has_method("get_infected")):
		if(!spawnedEnemies):
			var enemyCount = randi_range(1, 6)
			spawnedEnemies = true
			spawn_enemy(enemyTypeBasic, enemyCount)
