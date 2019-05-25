extends Area2D

func _ready():
	$'AnimationPlayer'.play("default")

func _on_moeda_body_entered(body):
	body.bau()
	$'som'.play()
	$'Timer'.start()
	$'AnimationPlayer'.play("fade")
	

func _on_Timer_timeout():
	get_node("shape").queue_free()
	queue_free()
	pass # Replace with function body.
