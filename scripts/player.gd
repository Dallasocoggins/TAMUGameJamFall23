extends CharacterBody2D


@export var speed = 300.0


@export var jumpVelocity = -400.0
@export var jumpCountMax = 2
@export var jumpLowMultiplier = 2; # Used for falling faster when jump button is let go of early
var jumpCountCurrent = jumpCountMax

@export var fallMultipler = 2.5

var dashEnabled = true
@export var dashSpeed = 900

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Add extra forces for faster falling after jumping and to end jump early
	if velocity.y >= 0 && not is_on_floor():
		velocity.y += gravity * (fallMultipler - 1) * delta
	elif velocity.y < 0 && not is_on_floor() && not Input.is_action_pressed("ui_accept"):
		velocity.y += gravity * (jumpLowMultiplier - 1) * delta
	elif is_on_floor():
		jumpCountCurrent = jumpCountMax

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and jumpCountCurrent >= 1:
		velocity.y = jumpVelocity
		jumpCountCurrent -= 1
	

	# Get the input direction and handle the movement/deceleration.
	# As good pactice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
