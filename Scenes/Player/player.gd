extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var land_effect = preload("res://Scenes/Effects/land/land_effect.tscn")
@onready var jump_effect = preload("res://Scenes/Effects/Jump/JumpEffect.tscn")


var state = "idle"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
	
	
	# Handling animations and state
	# Check for facing
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
		
	return new_state
	
