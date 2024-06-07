extends SubViewport

@onready var camera = $"Camera2D"
@onready var minimap_marker = $"../MinimapMarker"
@onready var position_marker = $"../Marker2D"

func _physics_process(_delta):
	camera.position = owner.find_child("player").position / 27
	minimap_marker.rotation = (position_marker.position-get_mouse_position()).angle() - 1.57
