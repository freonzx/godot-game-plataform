extends KinematicBody2D

var sentido = 1

func _ready():
	get_node("AnimatedSprite").play("default")
	set_physics_process(true)
	
func _physics_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta * sentido * rand_range(0.6,0.8)
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
	# Imortal
	pass

func _on_Timer_timeout():
	$'AnimatedSprite'.queue_free()
