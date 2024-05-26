extends ParallaxBackground
var direction:Vector2 = Vector2(-1,0)
var speed:int = 100

func _physics_process(delta):
	scroll_base_offset += direction * speed * delta
