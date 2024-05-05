extends Area2D
@onready var global_variables = get_node("/root/GlobalVariables")

@onready var labelNoItems = $CanvasLayer/Label
@onready var labelNoGas = $CanvasLayer/Label2
@onready var labelNoSuitcase = $CanvasLayer/Label3
@onready var labelAllItems = $CanvasLayer/Label4
# Called when the node enters the scene tree for the first time.
func _ready():
	labelNoItems.visible = false
	labelNoGas.visible = false
	labelNoSuitcase.visible = false
	labelAllItems.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if(body.has_method("get_infected")):
		if(!global_variables.hasGascan && !global_variables.hasSuitcase):
			labelNoItems.visible = true
			await get_tree().create_timer(3).timeout
			labelNoItems.visible = false

		if(!global_variables.hasGascan && global_variables.hasSuitcase):
			labelNoGas.visible = true
			await get_tree().create_timer(3).timeout
			labelNoGas.visible = false

		if(global_variables.hasGascan && !global_variables.hasSuitcase):
			labelNoSuitcase.visible = true
			await get_tree().create_timer(3).timeout
			labelNoSuitcase.visible = false

		if(global_variables.hasGascan && global_variables.hasSuitcase):
			labelAllItems.visible = true
			await get_tree().create_timer(3).timeout
			labelAllItems.visible = false
			get_tree().change_scene_to_file("res://scenes/mission_complete.tscn")
