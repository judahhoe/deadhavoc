extends Control

var main_scene = "res://scenes/main.tscn"
@onready var plunger = $Plunger
var start_plunger_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	start_plunger_pos = plunger.position
	ResourceLoader.load_threaded_request(main_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress = []
	ResourceLoader.load_threaded_get_status(main_scene, progress)
	$VBoxContainer/ProgressBar.value = progress[0]*100
	$VBoxContainer/ProgressNumber.text = str(progress[0] * 100) + "%"
	plunger.position.x = start_plunger_pos.x - (progress[0] * 200)
	
	if progress[0] == 1:
		await get_tree().create_timer(1).timeout
		var packed_scene = ResourceLoader.load_threaded_get(main_scene)
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_packed(packed_scene)
