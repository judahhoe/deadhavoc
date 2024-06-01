extends Node2D

@onready var animationPlayer = $AnimationPlayer

@onready var enemyTypeBasic_0 = preload("res://scenes/basic_zombie_0.tscn")
@onready var enemyTypeBasic_1 = preload("res://scenes/basic_zombie_1.tscn")
@onready var enemyTypeBasic_2 = preload("res://scenes/basic_zombie_2.tscn")
@onready var enemyTypeQuick = preload("res://scenes/quick_enemy.tscn")
@onready var enemyTypeBlob = preload("res://scenes/blob_zombie.tscn")
@onready var enemyTypeBig = preload("res://scenes/big_zombie.tscn")

@onready var sound = $"SewerSound"
@onready var respawnTimer = $Timer

var spawnedEnemies = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy(enemy_count):
	var enemy_type
	animationPlayer.play("open_sewer")
	sound.play()
	await get_tree().create_timer(2.0).timeout
	while (enemy_count>0):
		var random = randi_range(1,40)
		if (random >= 7 && random <=8):
			enemy_type = enemyTypeBig
		elif (random == 9):
			enemy_type = enemyTypeBlob
		elif (random >= 1 && random <= 6):
			enemy_type = enemyTypeQuick
		else:
			var randomize_basic = randi_range(1,3)
			if (randomize_basic == 1):
				enemy_type = enemyTypeBasic_0
			if (randomize_basic == 2):
				enemy_type = enemyTypeBasic_1
			if (randomize_basic == 3):
				enemy_type = enemyTypeBasic_2
		var spawned_enemy = enemy_type.instantiate()
		owner.add_child.call_deferred(spawned_enemy)
		spawned_enemy.position = global_position
		spawned_enemy.visible = true
		await get_tree().create_timer(randf_range(2.0,3.0)).timeout
		enemy_count -= 1
	animationPlayer.play("close_sewer")
	sound.play()


func _on_detect_player_body_entered(body):
		if(body.has_method("get_infected")):
			if(!spawnedEnemies):
				var enemyCount = randi_range(3, 10)
				spawnedEnemies = true
				respawnTimer.start()
				spawn_enemy(enemyCount)


func _on_timer_timeout():
	spawnedEnemies = false
