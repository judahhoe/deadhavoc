extends Node2D

@onready var particles = $CPUParticles2D
@onready var particles2 = $CPUParticles2D2
@onready var sprite = $AnimatedSprite2D

@onready var medkit = preload("res://scenes/medkit.tscn").instantiate()
@onready var ammobox = preload("res://scenes/ammobox.tscn").instantiate()

#pickups vars
var pickup : Pickup
var launch_speed : float = 100
var launch_time :float = 0.25
var drop

var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dropitem(item):
	match item :
		"medkit":
			pickup = medkit
		"ammo":
			pickup = ammobox
	owner.add_child.call_deferred(pickup)
	pickup.position = self.global_position
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	pickup.launch(direction * launch_speed, launch_time)

func handle_hit():
	if (health > 0):
		health -= 1
	if (health <= 0):
		particles.emitting = true
		particles2.emitting = true
		sprite.visible = false
		destroy();
	if (health == 2):
		sprite.frame = 1
	if (health == 1):
		sprite.frame = 2

func destroy():
	drop = randi_range(1,100)
	if(drop>=1 && drop <=20):
		dropitem("medkit")
	if(drop>20 && drop <=40):
		dropitem("ammo")
	await get_tree().create_timer(1).timeout
	queue_free()
