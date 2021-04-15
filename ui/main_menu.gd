extends Node2D

signal start_game
signal graphics_changed(value)
signal touch_changed(value)

var mouse_position = Vector2()

func _ready():
	var mouse_curser = preload("res://assets/mouse_cursor.png")
	Input.set_custom_mouse_cursor(mouse_curser, Input.CURSOR_ARROW, Vector2(8, 8))


func _draw():
	randomize()
	var color = randf() / 10
	draw_line(Vector2(0, mouse_position.y), Vector2(800, mouse_position.y), Color(color, color, color))
	draw_line(Vector2(mouse_position.x, 0), Vector2(mouse_position.x, 600), Color(color, color, color))


func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position
		update()


func _on_PlayButton_pressed():
	emit_signal("start_game")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Graphics_toggled(button_pressed):
	emit_signal("graphics_changed", button_pressed)


func _on_Touch_toggled(button_pressed):
	emit_signal("touch_changed", button_pressed)
