extends Area2D

signal finished

var t = 0

func _ready():
	t = 0


func _process(delta):
	t += delta
	position.y += sin(t*2) / 2


func _on_Finish_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("finished")
	
