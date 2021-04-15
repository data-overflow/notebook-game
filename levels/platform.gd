extends KinematicBody2D

var time = 0.0

func _ready():
	pass


func _physics_process(delta):
	time += delta
	#move_and_slide(Vector2(0, sin(time) * 200 ))
	position.y = sin(time) * 120 + 300
	#position.x = sin(time) * 120 + 400
