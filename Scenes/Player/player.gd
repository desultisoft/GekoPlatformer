extends CharacterBody2D

@onready var land_effect = preload("res://Scenes/Effects/land/land_effect.tscn")
@onready var jump_effect = preload("res://Scenes/Effects/Jump/JumpEffect.tscn")

@export var movement_speed = 200.0
@export var jump_power = -400.0
@export var coyote_time = 0.15
@export var saved_jump_time = 1.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var state = "idle"
var saved_jump = false
var coyote_save = false
var coyote_timer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump. If in air save the jump input, so he jumps as soon as he hits the ground
	if Input.is_action_just_pressed("ui_accept"):
		saved_jump_time_handler()

	if saved_jump and (is_on_floor() or coyote_save):
		velocity.y = jump_power
		saved_jump = false
		coyote_save = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * movement_speed
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
	
	
	# Set image facing
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	# Set animations
	if direction == 0 and is_on_floor():
		$AnimatedSprite2D.play("Idle")
		state = handle_state_change(state, "idle")
	elif is_on_floor():
		$AnimatedSprite2D.play("Walking")
		state = handle_state_change(state, "walking")
	if not is_on_floor() and velocity.y <= 0:
		$AnimatedSprite2D.play("Jump")
		state = handle_state_change(state, "soaring")
	elif not is_on_floor():
		$AnimatedSprite2D.play("Fall")
		state = handle_state_change(state, "falling")

	# Move 
	move_and_slide()
	

func handle_state_change(old_state, new_state):
	var was_grounded = (old_state == "idle" or old_state == "walking")
	var is_grounded = (new_state == "idle" or new_state == "walking")
	if was_grounded and new_state == "soaring":
		var dust = jump_effect.instantiate()
		get_parent().get_parent().add_child(dust)
		dust.global_position = global_position
		dust.flip_h = !$AnimatedSprite2D.flip_h 
	if old_state == "falling" and is_grounded:
		var dust = land_effect.instantiate()
		get_parent().get_parent().add_child(dust)
		dust.global_position = global_position
		dust.flip_h = !$AnimatedSprite2D.flip_h
	if was_grounded and new_state == "falling":
		coyote_time_handler()
		
	return new_state
	
func coyote_time_handler():
	coyote_save = true
	await get_tree().create_timer(coyote_time).timeout
	coyote_save = false

func saved_jump_time_handler():
	saved_jump = true
	await get_tree().create_timer(coyote_time).timeout
	saved_jump = false
