extends Node2D

@onready var tint: Node2D = $Tint
@onready var spawner_group: Node2D = $Tint/SpawnerGroup
@onready var camera_2d: Camera2D = $Tint/SideCharacter/Camera2D
@onready var player: CharacterBody2D = $Tint/SideCharacter
@onready var tile_maps: Node2D = $Tint/TileMaps
@onready var tile_depo: Node2D = $Tint/TileDepo

@onready var player_follower: Node2D = $Tint/PlayerFollower

var distance_traveled: float = 0.0
var end_reached: bool = false
const PALETTE = [Color(0, 0, 0), Color(255, 255, 255), Color(215, 38, 56), Color(244, 96, 54), Color(255, 210, 63), Color(38, 84, 124), Color(33, 161, 121), Color(0, 252, 243)]


func _ready() -> void:
	$UI.visible = true


func _process(delta: float) -> void:
	var player_pos:Vector2 = player.global_position 
	if player_follower:
		player_follower.global_position.x = player_pos.x
	if !spawner_group:
		return
	
	spawner_group.global_position.x = player_pos.x + 160.0 
		#get_viewport_rect().size.x * 0.5 + some offset is alreay applied
	
	if distance_traveled < player_pos.x:
		distance_traveled = player_pos.x 
		var timer_change: float
		if distance_traveled > 10000.0: timer_change = 1.0
		elif distance_traveled > 8000.0: timer_change = 2.0
		elif distance_traveled > 6000.0: timer_change = 3.0
		elif distance_traveled > 4000.0: timer_change = 4.0
		elif distance_traveled > 2000.0: timer_change = 5.0
		elif distance_traveled > 1000.0: timer_change = 6.0
		else: timer_change = 7.0
		for spawner in spawner_group.get_children():
			spawner.spawn_delay = timer_change
		if distance_traveled > tile_maps.get_child_count() * 480 - 300:
			move_level_chunk()
	

	#tint.modulate = PALETTE[3]
func move_level_chunk():
	if tile_depo.get_child_count() > 0:
		var new_chunk:TileMapLayer = tile_depo.get_child(randi()%tile_depo.get_child_count())
		new_chunk.reparent(tile_maps)
		new_chunk.global_position.x = 480 * (tile_maps.get_child_count()-1)
	elif !end_reached:
		end_reached = true
		$Tint/TileMapEnd.global_position.x = 480 * (tile_maps.get_child_count())
		$Tint/TileMapEnd.reparent(tile_maps)

func generate_level_chunk():
	pass
	#var new_chunk = load()
	#new_chunk.instantiate()
	#new_chunk.global_position.x = 256 * tile_maps.get_child_count()
