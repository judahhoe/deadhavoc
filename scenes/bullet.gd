extends Area2D


@export var speed = 30

@onready var kill_timer = $KillTimer
@onready var impact_manager = $"../../ImpactManager"
signal bullet_impacted(position, direction)
var direction := Vector2.ZERO

func _ready():
	kill_timer.start()
	get_node(".").connect("bullet_impacted",impact_manager.handle_bullet_impacted)

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
	print(body)
	if (body.has_method("handle_hit")):
		emit_signal("bullet_impacted",global_position,direction)
		body.handle_hit()
		queue_free()
