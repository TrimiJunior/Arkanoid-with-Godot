extends Node

func _ready():
	$title_margin/menu/lose_title/text/losses.text = "losses: "+str(GLOBALS.losses)

func _on_button_replay_pressed():
	TRANSITION.change_scene_loc(get_tree().current_scene.get_filename())
	get_tree().paused = false

func _on_button_quit_pressed():
	get_tree().quit()
