extends Control

@onready var playbutton = $VBoxContainer/PlayButton
@onready var perksbutton = $VBoxContainer/PerksButton
@onready var optionsbutton = $VBoxContainer/OptionsButton
@onready var quitbutton = $VBoxContainer/QuitButton
@onready var sound = $ButtonClickSplatter

# Called when the node enters the scene tree for the first time.
func _ready():
	playbutton.grab_focus()
	if(!BackgroundMusic.isMusicPlaying):
		BackgroundMusic.play_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.d
func _process(delta):
	pass


func _on_play_button_pressed():
	sound.play()
	playbutton.icon = load("res://assets/menus/menu_plank_bloody_0.png")
	await get_tree().create_timer(0.2).timeout
	if(BackgroundMusic.isMusicPlaying):
		BackgroundMusic.stop_music()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_perks_button_pressed():
	sound.play()
	perksbutton.icon = load("res://assets/menus/menu_plank_bloody_1.png")
	await get_tree().create_timer(0.2).timeout


func _on_options_button_pressed():
	sound.play()
	optionsbutton.icon = load("res://assets/menus/menu_plank_bloody_2.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu_options.tscn")


func _on_quit_button_pressed():
	sound.play()
	quitbutton.icon = load("res://assets/menus/menu_plank_bloody_3.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func _on_play_button_mouse_entered():
	playbutton.modulate = "909090"
	playbutton.grab_focus()


func _on_play_button_mouse_exited():
	playbutton.modulate = "ffffff"
	playbutton.release_focus()

func _on_play_button_focus_entered():
	playbutton.modulate = "909090"
	playbutton.grab_focus()


func _on_play_button_focus_exited():
	playbutton.modulate = "ffffff"
	playbutton.release_focus()


func _on_perks_button_mouse_entered():
	perksbutton.modulate = "909090"
	perksbutton.grab_focus()


func _on_perks_button_mouse_exited():
	perksbutton.modulate = "ffffff"
	perksbutton.release_focus()

func _on_perks_button_focus_entered():
	perksbutton.modulate = "909090"
	perksbutton.grab_focus()


func _on_perks_button_focus_exited():
	perksbutton.modulate = "ffffff"
	perksbutton.release_focus()

func _on_options_button_mouse_entered():
	optionsbutton.modulate = "909090"
	optionsbutton.grab_focus()


func _on_options_button_mouse_exited():
	optionsbutton.modulate = "ffffff"
	optionsbutton.release_focus()

func _on_options_button_focus_entered():
	optionsbutton.modulate = "909090"
	optionsbutton.grab_focus()


func _on_options_button_focus_exited():
	optionsbutton.modulate = "ffffff"
	optionsbutton.release_focus()

func _on_quit_button_mouse_entered():
	quitbutton.modulate = "909090"
	quitbutton.grab_focus()


func _on_quit_button_mouse_exited():
	quitbutton.modulate = "ffffff"
	quitbutton.release_focus()


func _on_quit_button_focus_entered():
	quitbutton.modulate = "909090"
	quitbutton.grab_focus()


func _on_quit_button_focus_exited():
	quitbutton.modulate = "ffffff"
	quitbutton.release_focus()
