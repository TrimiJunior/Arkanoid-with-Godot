extends Node


func _on_button_quit_pressed():
	get_tree().quit() #  salir del juego

func _on_button_next_pressed():
	var current_level:Node = get_tree().current_scene  # obtengo el nivel acual del arbol de escenas
	var next_level:String = current_level.name # obtengo su nombre 
	next_level = next_level.substr(5)  # obtengo el ultimo caracter del nombre
	var number:int = next_level.to_int()+1  # y le sumo 1 para asi avanzar de nivel
	next_level = "level"+str(number)
	print(next_level)
	TRANSITION.change_scene_loc("res://levels/"+next_level+".tscn")  # cambio de escena, a el siguiente nivel 
	get_tree().paused = false  # despauso el juego
