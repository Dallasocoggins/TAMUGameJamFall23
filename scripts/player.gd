extends CharacterBody2D


@export var run_max_speed = 500.0
@export var run_acceleration = 2000.0
@export var run_deceleration = 4000.0
@export var turn_acceleration = 10000.0

@export var jump_velocity = -400.0
@export var jump_low_multiplier = 2 # Used for falling faster when jump button is let go of early
@export var fall_acceleration_multiplier = 1.5
@export var terminal_velocity = 1000.0
@export var jump_count_max = 2

@export var dash_speed = 900

var last_velocity_sign = 1
var jump_count_current = jump_count_max
var dash_enabled = true
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
	elif is_on_floor():
		jump_count_current = jump_count_max
		
	# You can't fall faster than terminal velocity
	velocity.y = min (velocity.y, terminal_velocity)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and jump_count_current >= 1:
		velocity.y = jump_velocity
		jump_count_current -= 1
	

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x += direction * delta * (run_acceleration if sign(direction) == sign(velocity.x) else turn_acceleration)
	else:
		var new_velocity = velocity.x - sign(velocity.x) * delta * run_deceleration
		velocity.x = new_velocity if sign(new_velocity) == sign(velocity.x) else 0
		
	velocity.x = clampf(velocity.x, -run_max_speed, run_max_speed)
	
	if (sign(velocity.x) != last_velocity_sign && sign(velocity.x) != 0):
		sprite.flip_h = sign(velocity.x) <  0
		last_velocity_sign = sign(velocity.x)

	move_and_slide()
