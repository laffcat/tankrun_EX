extends CharacterBody2D

@export var health := 6
@export var speed = 100.0

var vel_add := Vector2.ZERO
var vel_add_tween : Tween
var vel_mult := 1.0
var active := true
var invuln := false
var dir = Vector2.LEFT

func pause(): active = false
func unpause(): active = true

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	
func _physics_process(delta: float) -> void:
	if active:
		var vel_base : Vector2
		if !invuln:
			
			vel_base = dir * speed * vel_mult
		else: vel_base = Vector2.ZERO
		velocity = vel_base + vel_add
		move_and_slide()
	if global_position.x < -200.0:
		queue_free()

func damage(dmg : int, dir : Vector2):
	if invuln: return
	health -= dmg
	if health < 1:
		vel_add = Vector2.DOWN * 60.0 
		set_collision_layer_value(2, false)
		$Area2D.monitoring = false
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, false)
		$AnimatedSprite2D.play("death")
		Globals.score += 10
		await $AnimatedSprite2D.animation_finished
		queue_free()
	else:
		$Area2D.monitoring = false
		set_collision_mask_value(1, false)
		vel_add = dir * 150.0 
		vel_mult = 0.0
		$AnimatedSprite2D.play("hit")
		if vel_add_tween: vel_add_tween.kill()
		vel_add_tween = create_tween()
		vel_add_tween.tween_property(self, "vel_add", Vector2.ZERO, .5)
		invuln = true
		await get_tree().create_timer(.3).timeout
	
		invuln = false
		$Area2D.monitoring = true
		set_collision_mask_value(1, true)
		
		await vel_add_tween.finished
		if vel_add_tween: vel_add_tween.kill()
		vel_add_tween = create_tween()
		vel_add_tween.tween_property(self, "vel_mult", 1.0, .4)


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("getting_hit"):
		body.getting_hit()
