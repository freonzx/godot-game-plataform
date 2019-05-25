extends KinematicBody2D

onready var rayE = get_node("rayE")
onready var rayD = get_node("rayD")
onready var sprite = get_node("sprite")

var vivo = true
signal morreu
signal fim
# Items
signal moeda
signal bau
signal heart

var left
var right
var up
var fim

#---------------------------------------------------------------------------------

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1300.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 9000
const WALK_MIN_SPEED = 150
const WALK_MAX_SPEED = 400
const STOP_FORCE = 6000
const JUMP_SPEED = 850
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = (Input.is_action_pressed("move_left") or left) and vivo
	var walk_right = (Input.is_action_pressed("move_right") or right or fim) and vivo
	var jump = (Input.is_action_pressed("jump") or up) and vivo
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		pular()
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	var no_chao = rayE.is_colliding() or rayD.is_colliding()
	
	if walk_right:
		sprite.set_flip_h(false)
		sprite.set_position(Vector2(30,9))
	if walk_left:
		sprite.set_flip_h(true)
		sprite.set_position(Vector2(-26,9))
		
	if(walk_left or walk_right) and no_chao:
#		sprite.play("default")
		pass
	elif(walk_left or walk_right):
		sprite.stop()
		sprite.set_frame(2)
	elif no_chao == false:
		sprite.play("jump")
	else:
		sprite.stop()
		sprite.set_frame(1)
		
	if no_chao:
		sprite.play("default")
	elif no_chao == false:
		sprite.play("jump")
	
	if get_position().y > 900: morreu()

func _on_pes_body_entered(body):
	if not vivo: return
	pular()
	body.esmagar()
	
func pular():
	$'jump'.play()
	velocity.y = -JUMP_SPEED
	jumping = true

func _on_corpo_body_entered(body):
	if not vivo: return
	print("morreu")
	morreu()

func morreu():
	if not vivo: return
	vivo = false
	velocity.y = -500
	get_node("shape").set_deferred("disabled", true)
	emit_signal("morreu")
	

func _on_cabeca_body_entered(body):
	if not vivo: return
	if body.has_method("destruir"):
		body.destruir()


func _on_touchLeft_pressed():
	left = true


func _on_touchLeft_released():
	left = false


func _on_touchRight_pressed():
	right = true


func _on_touchRight_released():
	right = false


func _on_touchUp_pressed():
	up = true


func _on_touchUp_released():
	up = false

func reviver():
	velocity = Vector2(0,0)
	get_node("shape").set_deferred("disabled", false)
	get_node("camera").make_current()
	vivo = true
	fim = false

func _on_fim_body_entered(body):
	fim = true
	emit_signal("fim")
	
func moeda():
	emit_signal("moeda")
	
func bau():
	emit_signal("bau")
	
func heart():
	emit_signal("heart")
