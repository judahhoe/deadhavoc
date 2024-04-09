extends GPUParticles2D

@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = lifetime
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
