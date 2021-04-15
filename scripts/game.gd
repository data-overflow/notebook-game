extends Node2D

export var level = 0

const death_audio = preload("res://assets/audio/sfx_sounds_damage3.wav")
const end_auido = preload("res://assets/audio/sfx_sounds_interaction17.wav")

var level_resource = null
var player_key = false

onready var anim = $Effects/ColorRect/AnimationPlayer
onready var audio = $AudioStreamPlayer
onready var label = $CanvasLayer/Label


func _ready():
	var next_level = get_level_resource(level).instance()
	next_level.add_to_group('level')
	call_deferred("add_child", next_level)
	anim.play("blackout")
	var endgame = next_level.get_node_or_null("Endgame")
	if endgame:
		endgame.connect("finished", self, "on_end_game")
	var door = next_level.get_node_or_null("Door")
	if door:
		door.connect("key_lost", self, "_on_key_lost")
	next_level.get_node("Player").connect("key_taken", self, "_on_key_taken")
	next_level.connect("level_complete", self, "on_level_complete")
	next_level.connect("player_dead", self, "on_player_dead")
	next_level.connect("player_restart", self, "on_player_restart")


func get_level_resource(lv):
	level_resource = load("res://levels/level"+str(lv)+".tscn")
	return level_resource


func on_level_complete():
	switch_level(1)
	"""
	play_audio(end_auido)
	var this_level = get_tree().get_nodes_in_group("level")[0]
	this_level.disconnect("level_complete", self, "on_level_complete")
	this_level.disconnect("player_dead", self, "on_player_dead")
	this_level.queue_free()
	level += 1
	var next_level = get_level_resource(level).instance()
	call_deferred("add_child", next_level)
	next_level.add_to_group('level')
	anim.play("blackout")
	next_level.connect("level_complete", self, "on_level_complete")
	next_level.connect("player_dead", self, "on_player_dead")
	"""


func switch_level(lv):
	play_audio(end_auido)
	var this_level = get_tree().get_nodes_in_group("level")[0]
	this_level.disconnect("level_complete", self, "on_level_complete")
	this_level.disconnect("player_dead", self, "on_player_dead")
	this_level.disconnect("player_restart", self, "on_player_restart")
	this_level.queue_free()
	level += lv
	var next_level = get_level_resource(level).instance()
	
	call_deferred("add_child", next_level)
	next_level.add_to_group('level')
	anim.play("blackout")
	next_level.connect("level_complete", self, "on_level_complete")
	next_level.get_node("Player").connect("key_taken", self, "_on_key_taken")
	var endgame = next_level.get_node_or_null("Endgame")
	if endgame:
		endgame.connect("finished", self, "on_end_game")
	var door = next_level.get_node_or_null("Door")
	if door:
		door.connect("key_lost", self, "_on_key_lost")
	next_level.connect("player_dead", self, "on_player_dead")
	next_level.connect("player_restart", self, "on_player_restart")


func on_player_restart():
	play_audio(death_audio)
	var this_level = get_tree().get_nodes_in_group("level")[0]
	this_level.disconnect("level_complete", self, "on_level_complete")
	this_level.disconnect("player_dead", self, "on_player_dead")
	this_level.disconnect("player_restart", self, "on_player_restart")
	this_level.queue_free()
	var next_level = level_resource.instance()
	add_child(next_level)
	next_level.add_to_group('level')
	var endgame = next_level.get_node_or_null("Endgame")
	if endgame:
		endgame.connect("finished", self, "on_end_game")
	var door = next_level.get_node_or_null("Door")
	if door:
		door.connect("key_lost", self, "_on_key_lost")
	_on_key_lost()
	next_level.get_node("Player").connect("key_taken", self, "_on_key_taken")
	next_level.connect("level_complete", self, "on_level_complete")
	next_level.connect("player_dead", self, "on_player_dead")
	next_level.connect("player_restart", self, "on_player_restart")
	anim.play("dead")
	anim.seek(0)
	anim.play("dead")


func on_player_dead():
	play_audio(death_audio)
	switch_level(-1)
	if level == 1:
		var this_level = get_tree().get_nodes_in_group("level")[0]
		this_level.get_node("Hints").text += "\n..START OVER FROM THE PREVIOUS LEVEL :P"
		
	anim.play("dead")
	anim.seek(0)
	anim.play("dead")


func play_audio(wav):
	audio.stream = wav
	audio.play()


func _on_key_taken():
	label.show()
	player_key = true


func _on_key_lost():
	label.hide()
	player_key = false


func on_end_game():
	var this_level = get_tree().get_nodes_in_group("level")[0]
	this_level.disconnect("level_complete", self, "on_level_complete")
	this_level.disconnect("player_dead", self, "on_player_dead")
	this_level.disconnect("player_restart", self, "on_player_restart")
	this_level.queue_free()
	
	var next_level = load("res://levels/levelend.tscn").instance()
	#add_child(next_level)
	call_deferred("add_child", next_level)
	next_level.add_to_group('level')
	var endgame = next_level.get_node_or_null("Endgame")
	if endgame:
		endgame.connect("finished", self, "on_end_game")
	var door = next_level.get_node_or_null("Door")
	if door:
		door.connect("key_lost", self, "_on_key_lost")
	next_level.get_node("Player").connect("key_taken", self, "_on_key_taken")
	next_level.connect("level_complete", self, "on_level_complete")
	next_level.connect("player_dead", self, "on_player_dead")
	next_level.connect("player_restart", self, "on_player_restart")
	anim.play("dead")
	anim.seek(0)
	anim.play("dead")


"""
func _process(delta):
	randomize()
	$Shaders/ColorRect.material.set_shader_param("aberration_amount", randf()*5)
"""
