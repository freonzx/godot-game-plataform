extends Area2D

func _on_moeda_body_entered(body):
	get_node("shape").queue_free()
	queue_free()
