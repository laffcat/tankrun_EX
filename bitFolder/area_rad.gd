extends Area2D

@export var rad:float = 1.0

func _ready() -> void:
	move_around()

func move_around() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	var distance:float = randf_range(-10, 20)
	for i in randi_range(3, 7):
		tween.tween_property(self, "position", Vector2(0.0 , distance), 3.2)
		#distance *= -0.8
	tween.tween_property(self, "position", Vector2(0.0, 20.0), 1.1)
	tween.tween_callback(move_around)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("iradiation"):
		body.iradiation(rad)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("iradiation"):
		body.iradiation(-rad)
