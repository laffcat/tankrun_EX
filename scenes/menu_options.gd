extends Node2D




func activate():
	visible = true
	$"..".current_button = $MainBtnBack

func deactivate(): 
	visible = false
