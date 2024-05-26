extends StaticBody2D

func _process(delta):
	if get_tree().get_current_scene().get_name() != "level2":
		$color_sprites.play("colors")
	else:
		$color_sprites.frame = 2
