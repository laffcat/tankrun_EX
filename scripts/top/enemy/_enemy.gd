class_name EnemyTop
extends CharacterBody2D


const SPEED = 80.0
var vel_add := Vector2.ZERO
var vel_add_tween : Tween
var vel_mult := 1.0
var active := true
var invuln := false
var offscreen_clock := 0.0
var offscreen := true:
	set(b):
		offscreen = b
		if !b: offscreen_clock = 0.0
const DESPAWN_TIME := 5.0
var health := 6

func pause(): active = false
func unpause(): active = true

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	
func _process(delta: float) -> void:
	if offscreen: 
		offscreen_clock += delta
		if offscreen_clock > DESPAWN_TIME:
			queue_free()
	
func _physics_process(delta: float) -> void:
	if active:
		var vel_base : Vector2
		if !invuln:
			var dir = global_position.direction_to(Globals.player.global_position)
			rotation = dir.angle()
			vel_base = dir * SPEED * vel_mult
		else: vel_base = Vector2.ZERO
		velocity = vel_base + vel_add
		move_and_slide()

func damage(dmg : int, dir : Vector2):
	if invuln: return
	health -= dmg
	vel_add = dir * 150.0 
	vel_mult = 0.0
	if vel_add_tween: vel_add_tween.kill()
	vel_add_tween = create_tween()
	vel_add_tween.tween_property(self, "vel_add", Vector2.ZERO, .5)
	
	invuln = true
	$Sprite2D.frame = 1
	await get_tree().create_timer(.3).timeout
	if health > 0:
		invuln = false
		$Sprite2D.frame = 0
	else:
		Globals.score += 10
		$Sprite2D.frame = 2
		await get_tree().create_timer(1.0).timeout
		queue_free()
	
	
	await vel_add_tween.finished
	if vel_add_tween: vel_add_tween.kill()
	vel_add_tween = create_tween()
	vel_add_tween.tween_property(self, "vel_mult", 1.0, .4)
		
	
