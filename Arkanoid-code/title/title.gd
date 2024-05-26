extends Node

var sound_on = true
var music_on = true

func _on_button_play_pressed():
	TRANSITION.change_scene_loc("res://levels/level1.tscn")

func _on_but_mouse_entered():
	if(sound_on):
		$focus_sound.play()

func _on_button_quit_pressed():
	get_tree().quit()

func _on_music_pressed():
	if(music_on):
		$back_sound.stop()
		change_tex_image("res://title/options/Music Square Button mutex.png",$options/music)
		music_on = false
	else:
		$back_sound.play()
		change_tex_image("res://title/options/Music Square Button.png",$options/music)
		music_on = true

func _on_sound_pressed():
	if(sound_on):
		change_tex_image("res://title/options/Audio Square Button mutex.png",$options/sound)
		sound_on = false
	else:
		change_tex_image("res://title/options/Audio Square Button.png",$options/sound)
		sound_on = true

func change_tex_image(path:String,button:TextureButton)->void:
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path)
	texture.create_from_image(image)
	button.set_normal_texture(texture)



