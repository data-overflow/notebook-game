extends Node2D

signal level_complete
signal player_dead
signal player_restart

func _ready():
	#TranslationServer.set_locale("en")
	#$Hints.text = tr("LEVEL2")
	pass


func _on_Finish_finished():
	emit_signal("level_complete")


func _on_Player_dead():
	emit_signal("player_dead")


func _on_Player_restart():
	emit_signal("player_restart")
