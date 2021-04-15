extends Node

var settings = {
	fullscreen = true
}

func _ready():
	pass


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F4 and event.pressed == false:
			OS.window_fullscreen = !OS.window_fullscreen
		elif event.scancode == KEY_ESCAPE and event.pressed == false:
			get_tree().quit(0)
