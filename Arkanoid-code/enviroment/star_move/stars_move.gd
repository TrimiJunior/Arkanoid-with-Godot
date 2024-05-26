extends Node
var star_scn:PackedScene = preload("res://enviroment/star_move/star.tscn")
export(int) var min_velocity = 200
export(int) var max_velocity = 300

func _ready():
	randomize()
	$timer_stars.start()

func _on_timer_stars_timeout():
	$path/star_pos.set_offset(randi())
	var star_node = star_scn.instance()
	star_node.position = $path/star_pos.position
	add_child(star_node)
	var rotation = $path/star_pos.rotation
	rotation += rand_range(-PI/4,PI/4)
	star_node.rotation = rotation
	star_node.set_linear_velocity(Vector2(rand_range(min_velocity,max_velocity),0).rotated(rotation))
