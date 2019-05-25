extends Node2D

onready var personagem = get_node("personagem")
onready var camera = get_node("dead_camera")

var moedas = 0
var bau = 0

var vidas = 3

func _ready():
	pass 

func change_camera():
	camera.set_global_position(personagem.get_node("camera").get_camera_position())
	camera.make_current()


func _on_personagem_morreu():
	$'Sounds/death'.play()
	change_camera()
	
	get_node("spawn_timer").start()
	vidas -= 1
	if vidas == 2:
		$'CanvasLayer/Panel/heart1'.set_texture(load('res://assets/hud_heartEmpty.png'))
	elif vidas == 1:
		$'CanvasLayer/Panel/heart2'.set_texture(load('res://assets/hud_heartEmpty.png'))
	elif vidas == 0:
		$'CanvasLayer/Panel/heart3'.set_texture(load('res://assets/hud_heartEmpty.png'))

func _on_spawn_timer_timeout():
	if vidas > 0:
		reviver()
	else:
		transition.fade_to('res://scenes/menu.tscn')

func reviver():
	personagem.set_position(get_node("spawn_point").get_position())
	personagem.reviver()

func _on_personagem_fim():
	change_camera()
#	get_node("spawn_timer").start()
	transition.fade_to('res://scenes/GameFase2.tscn')


func _on_personagem_moeda():
	moedas += 1
	get_node("CanvasLayer/Panel/coins").set_text(str(moedas))


func _on_personagem_bau():
	bau += 1
	get_node("CanvasLayer/Panel/chests").set_text(str(bau))


func _on_personagem_heart():
	if vidas < 3:
		vidas += 1
	
	if vidas == 3:
		$'CanvasLayer/Panel/heart3'.set_texture(load('res://assets/hud_heartFull.png'))
		$'CanvasLayer/Panel/heart2'.set_texture(load('res://assets/hud_heartFull.png'))
		$'CanvasLayer/Panel/heart1'.set_texture(load('res://assets/hud_heartFull.png'))
	elif vidas == 2:
		$'CanvasLayer/Panel/heart2'.set_texture(load('res://assets/hud_heartFull.png'))
		$'CanvasLayer/Panel/heart3'.set_texture(load('res://assets/hud_heartFull.png'))
	elif vidas == 1:
		$'CanvasLayer/Panel/heart3'.set_texture(load('res://assets/hud_heartFull.png'))
