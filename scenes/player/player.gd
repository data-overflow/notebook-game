extends KinematicBody2D

signal dead
signal restart
signal key_taken

export var flip = false
export var fall_multiplier = 2
export var low_jump_multiplier = 22
export var jump_velocity = 1000
export var jump_buffer_threshold = 0.15
export var gravity = 50
export var speed = 600
export var acceleration = 10
export var max_a = 100
export var hlerp = 0.4

const jump_audio = preload("res://assets/audio/sfx_movement_jump8.wav")
const ladder_audio = preload("res://assets/audio/sfx_movement_ladder3loop.wav")

var velocity = Vector2()
var on_ladder = false
var charge = Vector2()
var key_possessed = false
var jump_schedule = false
var jump_buffer = 0.0

enum {GROUND, AIR, LADDER}

onready var anim = $Animation
onready var audio = $AudioStreamPlayer2D
onready var sm = $StateMachine


func _ready():
	anim.playing = true
	key_possessed = false
	anim.flip_h = flip
	sm.add_state(GROUND)
	sm.add_state(AIR)
	sm.add_state(LADDER)


func _physics_process(delta):
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("jump")
	var restart = Input.is_action_just_released("restart")
	
	if restart:
		key_possessed = false
		emit_signal("restart")
	
	match sm.state:
		LADDER:
			audio.stream_paused = true
			velocity = Vector2()
			if Input.is_action_pressed("ui_up"):
				velocity.y = lerp(velocity.y, -speed, 0.5)
				audio.stream_paused = false
			if Input.is_action_pressed("ui_down"):
				velocity.y = lerp(velocity.y, speed, 0.5)
				audio.stream_paused = false
			if Input.is_action_pressed("ui_right"):
				anim.flip_h = false
				velocity.x = lerp(velocity.x, speed, 0.5)
			if Input.is_action_pressed("ui_left"):
				anim.flip_h = true
				velocity.x = lerp(velocity.x, -speed, 0.5)
			velocity.y = lerp(velocity.y, 0, 0.3)
		
		AIR, GROUND:
			velocity.y += gravity
			if velocity.y > 0:
				velocity += Vector2.UP * -9.81 * fall_multiplier
			elif velocity.y < 0 and Input.is_action_just_released("jump"):
				velocity += Vector2.UP * -9.81 * low_jump_multiplier
			
			if right or left:
				if right:
					anim.flip_h = false
					velocity.x = lerp(velocity.x, speed * Input.get_action_strength("ui_right"), hlerp)
					if charge.x > 0:
						charge.x += acceleration
					else:
						charge.x = 1
				if left:
					anim.flip_h = true
					velocity.x = lerp(velocity.x, -speed * Input.get_action_strength("ui_left"), hlerp)
					if charge.x < 0:
						charge.x -= acceleration
					else:
						charge.x = -1
			else:
				charge.x = 0

	if abs(charge.x) > max_a:
		charge.x = max_a * sign(charge.x)
	
	if jump:
		jump_schedule = true
	if jump_schedule:
		jump_buffer += delta
	else:
		jump_buffer = 0.0
	
	if is_on_floor():
		sm.switch_state(GROUND)
		velocity.x = lerp(velocity.x, 0, 0.05)
		if jump or (jump_schedule and jump_buffer < jump_buffer_threshold):
			play_audio(jump_audio)
			velocity = Vector2.UP * jump_velocity
		if abs(velocity.x) < 25:
			anim.animation = 'idle'
			if abs(velocity.x) < 5:
				velocity.x = 0
		else:
			anim.animation = 'run'
			
		jump_schedule = false
	else:
		if not on_ladder:
			#play_audio(land_audio)
			sm.switch_state(AIR)
			anim.animation = 'jump'
		else:
			sm.switch_state(LADDER)
			if abs(velocity.x) < 25:
				anim.animation = 'idle'
			else:
				anim.animation = 'run'
	velocity.x = lerp(velocity.x, 0, 0.16)
	velocity = move_and_slide(velocity , Vector2.UP, false, 4, PI/4, false)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group('danger'):
			emit_signal("dead")
		if collision.collider.is_in_group("box"):
			collision.collider.apply_central_impulse(-collision.normal * 100)# * charge)


func _on_Area_area_entered(area):
	if area.is_in_group("ladder"):
		play_audio(ladder_audio)
		on_ladder = true
		sm.switch_state(LADDER)
	elif area.is_in_group("key"):
		emit_signal("key_taken")
		key_possessed = true
		area.visible = false


func _on_Area_area_exited(area):
	if area.is_in_group("ladder"):
		audio.stop()
		on_ladder = false
		sm.switch_state(AIR)


func play_audio(wav):
	audio.stream = wav
	audio.stream_paused = false
	audio.playing = true
	audio.play()
