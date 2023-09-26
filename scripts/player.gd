extends CharacterBody2D

@export var run_max_speed = 1000.0
@export var run_acceleration = 5000.0
@export var run_deceleration = 7000.0
@export var turn_acceleration = 10000.0
@export var no_moving_on_ground_enabled = false

@export var jump_velocity = -2000.0
@export var jump_low_multiplier = 2 # Used for falling faster when jump button is let go of early
@export var fall_acceleration_multiplier = 1.1
@export var terminal_velocity = 5000.0
@export var bonus_jump_count_max = 1 # I renamed this to bonus jump count because the jump off the ground is free
@export var slow_fall_enabled = true
@export var slow_fall_terminal_velocity = 300.0

# These are the run controls for when you are midair
@export var air_run_acceleration = 2000.0
@export var air_run_deceleration = 1000.0
@export var air_turn_acceleration = 10000.0

# TODO: Implement dash
@export var dash_enabled = false
@export var dash_speed = 2000.0

@export var coyote_time = 0.1 # If you were on the floor in the last this many seconds, you can still jump
@export var jump_buffer = 0.1 # If you try to jump not on the floor but land on the floor within this many seconds, you can still jump

var last_velocity_sign = 1
var jump_count_current = bonus_jump_count_max
var coyote_time_countdown = 0
var jump_buffer_countdown = 0
@onready var sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Add extra forces for faster falling after jumping and to end jump early
	if velocity.y >= 0 && not is_on_floor():
		velocity.y += gravity * (fall_acceleration_multiplier - 1) * delta
	elif velocity.y < 0 && not is_on_floor() && not Input.is_action_pressed("jump"):
		velocity.y += gravity * (jump_low_multiplier - 1) * delta
	
	if is_on_floor():
		jump_count_current = bonus_jump_count_max
		coyote_time_countdown = coyote_time
		
	# You can't fall faster than terminal velocity
	velocity.y = min (velocity.y, slow_fall_terminal_velocity) if slow_fall_enabled and Input.is_action_pressed("jump") else min (velocity.y, terminal_velocity)

	# Handle Jump.
	if (Input.is_action_just_pressed("jump") and (jump_count_current >= 1 or is_on_floor() or coyote_time_countdown > 0)) \
		or (jump_buffer_countdown > 0 and is_on_floor()):
		velocity.y = jump_velocity
		if (not is_on_floor() and coyote_time_countdown <= 0):
			jump_count_current -= 1
		coyote_time_countdown = 0
		jump_buffer_countdown = 0
	elif Input.is_action_just_pressed("jump"):
		jump_buffer_countdown = jump_buffer
	
	if coyote_time_countdown > 0:
		coyote_time_countdown -= delta
	if jump_buffer_countdown > 0:
		jump_buffer_countdown -= delta
	

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	var current_run_acceleration
	var current_run_deceleration
	var current_turn_acceleration
	if is_on_floor():
		current_run_acceleration = run_acceleration
		current_run_deceleration = run_deceleration
		current_turn_acceleration = turn_acceleration
	else:
		current_run_acceleration = air_run_acceleration
		current_run_deceleration = air_run_deceleration
		current_turn_acceleration = air_turn_acceleration
	
	# If we are travelling faster then max speed, that's ok, but we should slow down even if the player is holding down left or right
	if direction and velocity.x == clampf(velocity.x, -run_max_speed, run_max_speed) and not (no_moving_on_ground_enabled and is_on_floor()):
		velocity.x += direction * delta * (current_turn_acceleration if sign(direction) == -sign(velocity.x) else current_run_acceleration)
		velocity.x = clampf(velocity.x, -run_max_speed, run_max_speed)
	else:
		var new_velocity = velocity.x - sign(velocity.x) * delta * (current_turn_acceleration if sign(direction) == -sign(velocity.x) else current_run_deceleration)
		velocity.x = new_velocity if sign(new_velocity) == sign(velocity.x) else 0
	
	if (sign(velocity.x) != last_velocity_sign && sign(velocity.x) != 0):
		sprite.flip_h = sign(velocity.x) <  0
		last_velocity_sign = sign(velocity.x)

	move_and_slide()
