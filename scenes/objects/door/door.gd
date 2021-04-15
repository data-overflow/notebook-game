extends KinematicBody2D

signal key_lost


func _ready():
	pass


func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		var player = area.get_parent()
		if player.key_possessed or get_parent().get_parent().player_key:
			$AnimationPlayer.play("open")
			$Hitbox.set_deferred("disabled", true)
			player.key_possessed = false
			emit_signal("key_lost")


func open_door():
	pass
