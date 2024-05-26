extends RigidBody2D
var frame:int
var sem :bool = true

func _on_vs_notifire_screen_exited():
	queue_free()

func _on_tramp_gift_body_entered(body:Node):
	if body.name == "player":
		GLOBALS.emit_signal("affect_player",self)
		queue_free()

func _process(delta):
	if is_inside_tree() and sem:
		frame = $caps_sprites.frame
		sem = false
