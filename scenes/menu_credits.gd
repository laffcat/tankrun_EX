extends Node2D



func activate():
	visible = true
	$"..".current_button = $Back

func deactivate(): 
	visible = false
