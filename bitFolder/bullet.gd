extends Node2D

var time := 3.0
var velocity := Vector2(300.0, 0)

var active := true

func pause(): active = false
func unpause(): active = true

func _ready():
	Globals.paused.connect(pause)
	Globals.unpaused.connect(unpause)
	


func _process(delta: float) -> void:
	if active:
		time -= delta
		if time <= 0.0: queue_free()

func _physics_process(delta: float) -> void:
	if active:
		global_position += velocity * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if active:
		active = false
		#velocity = Vector2.ZERO
		$AnimatedSmoke.visible = true
		$Sprite2D.visible = false
		#$Area2D.monitoring = false
		$Area2D.set_deferred("monitoring", false)
		if body.has_method("damage"):
			body.damage(1, Vector2.RIGHT)
		$AnimatedSmoke.play("default")
		await $AnimatedSmoke.animation_finished
		queue_free()
		
