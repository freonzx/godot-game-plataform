extends Node2D

func _on_play_pressed():
	print('Mudar tela')
	transition.fade_to('res://scenes/Game.tscn')


func _on_quit_pressed():
	get_tree().quit()
