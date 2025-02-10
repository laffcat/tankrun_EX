extends CharacterBody2D

@export var health := 10
@export var speed = 200.0

var player:CharacterBody2D
var active := true
var invuln := false
var jumping := true
var dashing := false
var cd := 0.0

func pause(): active = false
func unpause(): active = true

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	if dashing and cd > 1.5:
		cd = 0.0
		pass
		
	elif active:
		cd += delta
		var p_pos := player.global_position
		var dir := global_position.direction_to(p_pos)
		if absf(global_position.x - p_pos.x) > 480.0:
			global_position = Vector2(p_pos.x - 260.0, p_pos.y)
		elif global_position.distance_to(p_pos) > 260.0:
			velocity = Vector2.RIGHT * speed
			#run to right and when out of sight appear from left
			
		else:
			velocity.x +=  dir.x * speed
			
		if !is_on_floor() and !jumping:
			jumping = true
			velocity.y = -200.0
		elif is_on_floor():
			jumping = false
		else:
			velocity += get_gravity() * delta
		
		if absf(p_pos.y - global_position.y) < 20.0 and absf(p_pos.x - global_position.x) < 100.0:
			dash_atk(dir.x)
	
		if velocity.x < 0.0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	move_and_slide()


func damage(dmg : int, dir : Vector2):
	if invuln: return
	health -= dmg
	if health < 1:
		set_collision_layer_value(2, false)
		$Area2D.monitoring = false
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, false)
		Globals.score += 70
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()
	else:
		$Area2D.monitoring = false
		set_collision_mask_value(1, false)
		$AnimatedSprite2D.play("hit")
		invuln = true
		await get_tree().create_timer(.3).timeout
	
		invuln = false
		$Area2D.monitoring = true
		set_collision_mask_value(1, true)
		

func dash_atk(dir_x: float):
	dashing = true
	velocity = Vector2.ZERO 
	$AnimatedSprite2D.play("atk")
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "velocity", Vector2(dir_x, 0.0) * speed, 2.0)
	await tween.finished
	dashing = false


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("getting_hit"):
		body.getting_hit()
