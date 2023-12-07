extends Area2D

@export var speed = 30

@onready var kill_timer = $KillTimer

var direction := Vector2.ZERO

func _ready():
	kill_timer.start()

func _physics_process(delta):
	if(direction !=Vector2.ZERO):
		var velocity = direction * speed
		
		global_position += velocity

func set_direction(direction : Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if (body.has_method("handle_hit")):
		body.handle_hit()
		queue_free()
