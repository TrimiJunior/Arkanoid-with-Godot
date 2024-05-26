extends RigidBody2D

func _ready():
	pass 

func _on_vs_notifire_screen_exited():
	queue_free()
