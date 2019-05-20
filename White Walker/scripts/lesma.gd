extends KinematicBody2D

var sentido = 1
var vivo = true

func _ready():
	get_node("AnimatedSprite").play("walk")
	set_physics_process(true)
	
func _physics_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta * sentido * 0.6
	if sentido == 1 and new_offset >= 0.99999:
		sentido = -1
		get_parent().set_unit_offset(0.99999)
		get_node("AnimatedSprite").set_flip_h(true)
		
	elif sentido == -1 and new_offset <= 0:
		sentido = 1
		get_parent().set_unit_offset(0)
		get_node("AnimatedSprite").set_flip_h(false)
	else:
		get_parent().set_unit_offset(new_offset)

func esmagar():
	if not vivo: return
	vivo = false
	get_node("death").play()
	get_node("AnimatedSprite").stop()
	get_node("AnimatedSprite").play("dying")
	get_node("CollisionShape2D").queue_free()
	$'Timer'.start()
	set_physics_process(false)

func _on_Timer_timeout():
	$'AnimatedSprite'.queue_free()
