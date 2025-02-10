extends CharacterBody2D

signal update_ui(hp, rad)
signal died

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var run_sound: AudioStreamPlayer2D = $RunSound
@onready var landing: AudioStreamPlayer2D = $Landing

const BULLET = preload("res://bitFolder/bullet.tscn")
const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACC = 30.0

var hp:float = 12.0: #max 12
	set(f):
		hp = f
		update_ui.emit(hp, radiation)
var radiation:float = 0.0: #max 200
	set(f):
		radiation = f
		update_ui.emit(hp, radiation)
var inventory: int = 0

var iradiated:float = 0.0
var coyote := false
var jumping := false
var timer:float = 0.0
var invulnerable := false
var air_borne := true:
	set(b):
			if air_borne and !b:
				landing.play() 
			air_borne = b
	#can use peack velocity.y, sampled through _phys_process  to determin loudness of impact

func _physics_process(delta: float) -> void:
	timer += delta
	if iradiated < 0.0:
		iradiated = 0.0
	elif iradiated:
		radiation += iradiated * delta
		if radiation > 200.0: death()
	
	# Add the gravity.
	if not is_on_floor():
		air_borne = true
		velocity += get_gravity() * delta
		if !jumping:
			coyote = true
			coyote_timer.start()
			jumping = false
	else:
		air_borne = false
		jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
		coyote = false
	elif Input.is_action_just_pressed("jump") and coyote:
		velocity.y = JUMP_VELOCITY*0.8
		jumping = true
		coyote = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if direction < 0.0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		if $AnimationPlayer.current_animation != "hit":
			$AnimationPlayer.play("run")
		velocity.x = move_toward(velocity.x, direction * SPEED, ACC)
		
	else:
		velocity.x = move_toward(velocity.x, 0, ACC * 0.5)
		if !invulnerable:
			$AnimationPlayer.play("idle")

	move_and_slide()
	
	
	#Shoot left click
	if Input.is_action_just_pressed("atk1") and timer > 1.2:
		#play gun sound
		timer = 0.0
		var temp = BULLET.instantiate()
		temp.global_position = $Gun/Marker2D.global_position
		add_sibling(temp)
	
	#Sound
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and is_on_floor():
		if abs(velocity.x) > 190.0: #SPEED * 0.9
			
			if !run_sound.playing:
				run_sound.play()
	elif not is_on_floor():
		run_sound.stop()
	else:
		await run_sound.finished
		run_sound.stop()
		

func getting_hit() -> void:
	if invulnerable: return
	
	invulnerable = true
	$AnimationPlayer.play("hit")
	$Gun.visible = false
	timer = 0.0
	hp -= 1.0
	await get_tree().create_timer(1.0).timeout
	invulnerable = false
	$Gun.visible = true
	if hp <= 0.0:
		death()
		
func death() -> void:
	died.emit()
	#play animation?
	#game over signal -> option to restart


func _on_coyote_timer_timeout() -> void:
	coyote = false


func pick_up(amount: int):
	inventory += amount

func check_inv():
	pass

func iradiation(amount:float) ->void:
	iradiated += amount

#Sort death & restart screen; What does radiation do? - something about tint?; 
#Grab and leave gameplay - can we have multiple pathways? - can we proc generate? 
