extends Node2D

@onready var animationPlayer = $AnimationPlayer

@export var et : PackedScene
@export var ec : int

@onready var sound = $"SewerSound"

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(4.0).timeout
	spawn_enemy(et, ec)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy(enemy_type, enemy_count):
	animationPlayer.play("open_sewer")
	sound.play()
	await get_tree().create_timer(2.0).timeout
	while (enemy_count>0):
		var spawned_enemy = enemy_type.instantiate()
		owner.add_child.call_deferred(spawned_enemy)
		spawned_enemy.position = global_position
		await get_tree().create_timer(2.0).timeout
		enemy_count -= 1
	animationPlayer.play("close_sewer")
	sound.play()
