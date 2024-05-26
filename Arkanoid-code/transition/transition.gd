extends CanvasLayer

onready var anim_play: AnimationPlayer = $animation_player_tran

func change_scene_loc(path: String)-> void:
	layer = 1
	anim_play.play("transition")
	yield(anim_play,"animation_finished")
	print(path)
	$inicio.play()
	get_tree().change_scene(path)
	anim_play.play_backwards("transition")
	yield(anim_play,"animation_finished")
	layer = -1 

func _ready():
	layer = -1
