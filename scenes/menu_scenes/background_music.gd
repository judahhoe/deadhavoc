extends Node

var isMusicPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func play_music():
	$Music.play()
	isMusicPlaying = true
func stop_music():
	$Music.stop()
	isMusicPlaying = false
