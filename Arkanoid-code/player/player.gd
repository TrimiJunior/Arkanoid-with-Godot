extends KinematicBody2D
onready var current_level:Node = get_tree().current_scene
var speed = 8
var movement:Vector2 
var chance:int = 1
var ball_node:RigidBody2D = load("res://ball/ball.tscn").instance()  # cargar la pelota e instanciarla
signal last_chance

func _ready():
	GLOBALS.connect("affect_player",self,"player_power_up",[])
	connect("last_chance",self,"respaw")
	$text_gift/text.visible = false
	modulate.a = 1.0

func respaw():
	set_collision_mask_bit(2,false)  # desactivar la mascara de colisiones con los regalos
	chance = 0 # poner la oportunidad a cero
	current_level.lives.frame = 2  # cambiar el sprite de la vida 
	$respaw_anim.play("respaw") # iniciar la animacion del respaw
	add_child(ball_node)  # añadir la pelota como a la escena como hijo del player
	ball_node.set_name("ball")
	ball_node.game_started = true
	ball_node.position.y = -35 # estblecer su posicion
	$respaw_time.start() # iniciar el temporizador del respaw

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		movement = Vector2(-speed,0)
		move_and_collide(movement)
	if Input.is_action_pressed("ui_right"):
		movement = Vector2(speed,0)
		move_and_collide(movement)

func update_text(new_text:String):
	$text_gift/show_timer.start()
	$text_gift/text.visible = true
	$text_gift/text.text = new_text

func player_power_up(gift):
	$sound_pickup.play()
	assign_values(gift) 
	$timer.start()

func hide_text():
		$text_gift/show_timer.stop()
		$text_gift/text.visible = false

func assign_values(gift):
	var power_index:int = gift.frame
	var new_speed:int
	var scale:Vector2
	var shape_extents:float
	var new_time:int 
	var text_speed:String
	var text_long:String
	var text_time:String
	print(gift.name)
	if gift.is_in_group("power"):
		new_speed = 12
		scale = Vector2(1.4,1)
		shape_extents = 68.5
		new_time = current_level.seconds + 10
		text_speed = " +Speed"
		text_long = "Expand"
		text_time = "  +10s"
	elif gift.is_in_group("tramp"):
		new_speed = 4
		scale = Vector2(0.6,1)
		shape_extents = 31.5
		new_time = current_level.seconds - 10
		text_speed = " -Speed"
		text_long = "Reduce"
		text_time = "  -10s"
	if power_index == 0:
		speed = new_speed
		print(text_speed)
		update_text(text_speed)
	elif power_index == 1:
		$col_player.shape.extents.x = shape_extents
		$spr_player.scale = scale
		print(text_long)
		update_text(text_long)
	else :
		var game_time:Timer = get_node("/root/"+current_level.name+"/time_count/timer")
		game_time.wait_time = new_time
		current_level.seconds = new_time
		current_level.update_label()
		game_time.start()
		print(text_time)
		update_text(text_time)

func disable_power_up():
		speed = 8
		$col_player.shape.extents.x = 50
		$spr_player.scale = Vector2(1,1)

func timer_timeout():
	disable_power_up()

func _on_show_timer_timeout():
	hide_text()


func _on_respaw_time_timeout():
	set_collision_mask_bit(2,true) # activar la mascara de colisiones con los regalos
	ball_node.game_started = false
