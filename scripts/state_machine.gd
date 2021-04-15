class_name StateMachine
extends Node

var states = []
var state = null
var previous_state = null

onready var parent = get_parent()
onready var elapsed_time = 0.0


func _ready():
	pass


func _process(delta):
	elapsed_time += delta


func add_state(value):
	states.append(value)


func add_states(value):
	states.append_array(value)


func remove_state(value):
	var index = states.find(value)
	if index >= 0:
		states.remove(index)


func switch_state(new_state):
	previous_state = state
	state = new_state
	elapsed_time = 0.0
