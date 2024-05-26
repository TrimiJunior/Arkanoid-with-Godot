extends RigidBody2D
const SPEED_X = 130
const SPEED_Y = -400
var game_started = false
export(float) var prob_gift = 0.22
onready var current_level:Node = get_tree().current_scene
onready var over:AudioStreamPlayer = $over

func _input(event):
	if event.is_action_pressed("ui_accept") and not game_started:
		$particles.emitting = true
		if current_level.level_playing == false:
			current_level.start_game()
		linear_velocity = Vector2(SPEED_X,SPEED_Y)
		game_started= true
		set_as_toplevel(true)

func hit_blocks(body:Node): # cuando golpea un bloke
	$break.play()
	if(body.get_parent().get_child_count() == 1):# si es el ultimo bloque se detiene el juego
		print("YOU WIN")                         
		get_tree().paused = true
		queue_free()
		GLOBALS.losses = 0
		var win_scn = load("res://title/next_level.tscn") # carga la escena next_level
		current_level.add_child(win_scn.instance())   # se instancia como hijo del nivel actual
	else: generate_gift(body.position)  # si no es el ultimo bloque se llama a la funcion que genera un regalo
	body.queue_free()  # se elimina el bloque

func lose():
	var player_node = get_parent()
	if player_node.chance == 1:
		player_node.emit_signal("last_chance")
		set_as_toplevel(false)
	else:
		get_tree().paused = true  # detiene el juego
		print("GAME OVER, salio de la pantalla")
		$over.play()
		yield($over,"finished")  # espera a que finalize el sonido de perder
		#get_tree().current_scene.back_sound.stop()
		GLOBALS.losses+=1
		current_level.add_child(load("res://title/replay.tscn").instance())  # se instancia como hijo del nivel actual la escena replay
	queue_free()

func generate_gift(pos:Vector2):
	var prob:float = randf()    # genera un valor random float 
	var prob_2:int = randi()%2   # genera un valor random int de 0 a 1
	var affect_power_scn:PackedScene
	var affect_power_node:RigidBody2D
	var path:NodePath
	if prob < prob_gift: # si el valor random es menor que la probavilidad definida
		if prob_2 == 0: 
			affect_power_scn = load("res://enviroment/power_up.tscn")  # carga la escena del regalo
		else:
			affect_power_scn = load("res://enviroment/tramp_gift.tscn") 
		affect_power_node = affect_power_scn.instance()  # instanciar
		affect_power_node.position = pos     # le doy la posicion del bloque que se elimina
		current_level.add_child(affect_power_node) # se añade el regalo como hijo del nivel actual
		path = affect_power_node.get_path()
		random_gift(prob_2,path) # se llama a la funcion que genera un sprite random para el regalo

func random_gift(index:int,path:NodePath): # recibe un indice, 0 regalo y 1 regalo trampa
	var gift_sprites:AnimatedSprite
	if index == 0:  # si es un ragalo 
		gift_sprites = get_node(str(path)+"/gift_sprites") # se obtiene el nodo de tipo animated sprite del arbol de escena con esa direccion
	else: # es un regalo trampa
		gift_sprites = get_node(str(path)+"/caps_sprites")
	if current_level.seconds > 15: 
		gift_sprites.frame = randi()%3  # cambia a un frame random entre 0 y 2 
	else:
		gift_sprites.frame = randi()%2  # cambia a un frame random entre 0 y 1 , excluir la trampa del restar tiempo

func _physics_process(delta):
	for body in get_colliding_bodies(): # recorre los nodos con que colisiona
		if body.is_in_group("gr_blocks"):    # si pertenece al grupo de bloques
			hit_blocks(body)    # llama a la funcion hit_blocks con el bloque que colisiono
		else:
			$col_player.play()
	if (!$vs_notifire.is_on_screen()):  # si no se encuentra dentro de la pantalla
		lose()  # llama a la funcion lose

func _ready():
	$particles.emitting = false 
