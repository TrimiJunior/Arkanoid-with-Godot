extends Node
export onready var seconds:int = $time_count/timer.wait_time 
onready var lives:Sprite = $time_count/lives
var level_playing:bool
#onready var back_sound = $back_sound

func _ready():
	$time_count/count.text = "Time: "+ str(seconds)

func start_game():
	level_playing = true
	$time_count/timer.start()
	$time_count/one_second.start()
	if $back_sound.playing == false:
		$back_sound.play()

func one_second_timeout():
	seconds-=1
	update_label()

func _on_timer_timeout():
	var ball_node:RigidBody2D = get_tree().get_nodes_in_group("ball")[0]
	$time_count/count.text = "Time: 0"
	print("GAME OVER, Tiempo terminado")
	get_tree().paused = true
	ball_node.over.play()
	yield(ball_node.over,"finished")
	ball_node.queue_free()
	GLOBALS.losses+=1
	add_child(load("res://title/replay.tscn").instance())

func update_label():
	var text_count:String = "Time: "+str(seconds)
	$time_count/count.text = text_count
