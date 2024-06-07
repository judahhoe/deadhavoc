extends Area2D

@export var speed = 10

@onready var breakSound = $BreakSound
@onready var kill_timer = $KillTimer
@onready var particles1 = $CPUParticles2D
@onready var particles2 = $CPUParticles2D2
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

var direction := Vector2.ZERO

func _ready():
	kill_timer.start()

func _physics_process(delta):
	if(direction !=Vector2.ZERO):
		var velocity = direction * speed
		
		global_position += velocity
	rotate(-0.02)

func set_direction(direction : Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if (body.has_method("take_damage")):
		body.take_damage(50)
	
	sprite.visible = false
	collision.set_deferred("disabled", true)
	particles1.emitting = true
	particles2.emitting = true
	breakSound.play()
	await get_tree().create_timer(1.0).timeout
	queue_free()
