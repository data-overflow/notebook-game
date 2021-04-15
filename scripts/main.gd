extends Node

var graphics = true
var controller = false setget _controller_set

onready var game = preload("res://game.tscn")

func _ready():
	($HUD/Joystick as Control).set_process_input(controller)
	$MainMenu.connect("start_game", self, "_on_start_game")
	$MainMenu.connect("graphics_changed", self, "_on_graphics_changed")
	$MainMenu.connect("touch_changed", self, "_on_touch_changed")


func _on_start_game():
	var game_instance = game.instance()
	$MainMenu.queue_free()
	add_child(game_instance)
	game_instance.get_node("Shaders").get_node("ColorRect").visible = graphics


func _on_graphics_changed(value):
	graphics = value
	$MainMenu.get_node("Shader").visible = value


func _on_touch_changed(value):
	_controller_set(value)


func _controller_set(value):
	controller = value
	$HUD/Joystick.visible = value
	($HUD/Joystick as Control).set_process_input(value)
	$HUD/Jump.visible = value
