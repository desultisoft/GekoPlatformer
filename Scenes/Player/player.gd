extends CharacterBody2D

@onready var land_effect = preload("res://Scenes/Effects/land/land_effect.tscn")
@onready var jump_effect = preload("res://Scenes/Effects/Jump/JumpEffect.tscn")

@export var movement_speed = 200.0
@export var jump_power = -400.0
@export var coyote_time = 0.2
@export var jump_time = 0.1
@export var glide_gravity = 160.0
@export var glide_boost = 20.0
@export var glide_time = 4

const default_gravity = 980.0

var gravity = default_gravity
var x_boost = 0
var state = "idle"
var saved_jump = false
var coyote_save = false
var can_glide = false
var facing = 1


func _physics_process(delta):

	if Input.is_action_just_pressed("ui_accept"):
		saved_jump_time_handler()
	
	# Handle jumping and gliding
	if saved_jump and (is_on_floor() or coyote_save):
		velocity.y = jump_power
		saved_jump = false
		coyote_save = false
	elif saved_jump and can_glide and not is_on_floor():
		velocity.y = 0
		gravity = glide_gravity
		x_boost = glide_boost
		glide_time_handler()
		saved_jump = false
	elif saved_jump and not is_on_floor():
		gravity = default_gravity
		x_boost = 0
		saved_jump
		
		

	# Up/Down movement
	if is_on_floor():
		can_glide = true
		x_boost = 0
		gravity = default_gravity
	else:
		velocity.y += gravity * delta

	# Left/Right movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		facing = direction
	if direction:
		velocity.x = direction * movement_speed + x_boost*facing
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)+ x_boost*facing
		
		
		
	print(can_glide)
	move_and_slide()
	

#	# Set state
#	if direction == 0 and is_on_floor():
#		state = handle_state_change(state, "idle")
#	elif is_on_floor():
#		state = handle_state_change(state, "walking")
#	elif not is_on_floor() and velocity.y <= 0:
#		state = handle_state_change(state, "jumping")
#	elif not is_on_floor():
#		state = handle_state_change(state, "falling")
#
#	# Set image facing
#	if velocity.x > 0:
#		$AnimatedSprite2D.flip_h = false
#	elif velocity.x < 0:
#		$AnimatedSprite2D.flip_h = true

	
	

#func handle_state_change(old_state, new_state):
#	var was_grounded = (old_state == "idle" or old_state == "walking")
#	var is_grounded = (new_state == "idle" or new_state == "walking")
#	if was_grounded and new_state == "jumping":
#	if old_state == "falling" and is_grounded:
#
#	return new_state

func dust_thing():
	var dust = land_effect.instantiate()
	get_parent().get_parent().add_child(dust)
	dust.global_position = global_position
	dust.flip_h = !$AnimatedSprite2D.flip_h
	
func coyote_time_handler():
	coyote_save = true
	await get_tree().create_timer(coyote_time).timeout
	coyote_save = false

func saved_jump_time_handler():
	saved_jump = true
	await get_tree().create_timer(jump_time).timeout
	saved_jump = false

func glide_time_handler():
	can_glide = false
	await get_tree().create_timer(glide_time).timeout
	can_glide = true
