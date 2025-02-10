extends Area2D

@export var amount:int = 1
@export var enemy_spawn:PackedScene
#var temp = preload("res://bitFolder/skely.tscn")

var player:CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("pick_up"):
		player = body
		body.pick_up(amount)
		$AudioStreamPlayer2D.play()
		visible = false

func _on_audio_stream_player_2d_finished() -> void:
	if enemy_spawn:
		var spawn = enemy_spawn.instantiate()
		spawn.player = player
		add_sibling(spawn)
	queue_free()
