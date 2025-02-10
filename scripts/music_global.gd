extends AudioStreamPlayer

const MUSIC = preload("res://sounds/Music/Pallet_Color_GJ_Gameplay_155bpm_4_4.wav")

func _ready() -> void:
	stream = MUSIC
	volume_db = -9.0
	bus = "Music"
