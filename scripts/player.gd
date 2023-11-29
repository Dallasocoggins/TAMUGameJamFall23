class_name Player
extends CharacterBody2D

var angel_active = false
var no_moving_on_ground_enabled:
	get:
		return angel_active
var slow_fall_enabled:
	get:
		return angel_active
# The jump off the ground is free
var bonus_jump_count_max:
	get:
		if (angel_active):
			return 1
		else:
			return 0

var vampire_active = false

var disable_movement = false

@export var max_health = 100.0
var curr_health = max_health

@export var run_max_speed = 900.0
@export var run_acceleration = 5000.0
@export var run_deceleration = 7000.0
@export var turn_acceleration = 50000.0

@export var jump_velocity = -2000.0
@export var pogo_velocity = -2000.0
@export var jump_low_multiplier = 2 # Used for falling faster when jump button is let go of early
@export var fall_acceleration_multiplier = 1.1
@export var terminal_velocity = 5000.0
@export var slow_fall_terminal_velocity = 300.0

# These are the run controls for when you are midair
@export var air_run_acceleration = 2000.0
@export var air_run_deceleration = 1000.0
@export var air_turn_acceleration = 30000.0

@export var air_attack_max = 1

# TODO: Implement dash
@export var dash_enabled = false
@export var dash_speed = 2000.0

@export var coyote_time = 0.1 # If you were on the floor in the last this many seconds, you can still jump
@export var jump_buffer = 0.1 # If you try to jump not on the floor but land on the floor within this many seconds, you can still jump
@export var pogo_cooldown_time = 0.5

#@export var animation_idle_move_threshold = 10.0 # If you are moving slower than this sideways, play the idle animation


var last_velocity_sign = 1
var jump_count_current = bonus_jump_count_max
var coyote_time_countdown = 0
var jump_buffer_countdown = 0
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var air_attack_count_current = air_attack_max
var pogo_countdown = 0

@onready var angel_hud = $HUD/Angel
@onready var vampire_hud = $HUD/Vampire

@onready var drop_raycast = $RayCast2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Item = preload("res://scripts/item.gd")

func _ready():
	animation_player.play("idle")
	angel_hud.hide()
	vampire_hud.hide()

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
		air_attack_count_current = air_attack_max
		
	# You can't fall faster than terminal velocity
	if slow_fall_enabled and Input.is_action_pressed("jump"):
		velocity.y = min (velocity.y, slow_fall_terminal_velocity)
	else:
		velocity.y = min (velocity.y, terminal_velocity)

	# Handle Jump.
	if ((Input.is_action_just_pressed("jump") and (jump_count_current >= 1 or is_on_floor() or coyote_time_countdown > 0)) \
		or (jump_buffer_countdown > 0 and is_on_floor())) \
		and !disable_movement:
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
	if pogo_countdown > 0:
		pogo_countdown -= delta
	

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
		var acceleration = current_turn_acceleration if sign(direction) == -sign(velocity.x) else current_run_acceleration
		velocity.x += direction * delta * acceleration
		velocity.x = clampf(velocity.x, -run_max_speed, run_max_speed)
	else:
		var acceleration = current_turn_acceleration if sign(direction) == -sign(velocity.x) else current_run_deceleration
		var new_velocity = velocity.x - sign(velocity.x) * delta * acceleration
		velocity.x = new_velocity if sign(new_velocity) == sign(velocity.x) else 0
	
	if(direction == -1 and not disable_movement):
		sprite.flip_h = true
	elif(direction == 1 and not disable_movement):
		sprite.flip_h = false

	if direction != 0 and animation_player.current_animation == "idle":
		animation_player.play("run_right")
	elif direction == 0 and animation_player.current_animation == "run_right":
		animation_player.play("idle")
	
	if(disable_movement):
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func can_attack():
	return is_on_floor() or (air_attack_count_current != 0)

func attack():
	if not is_on_floor():
		air_attack_count_current -= 1
	animation_player.queue("RESET")

func _process(float) -> void:
	if can_attack():
		if  Input.is_action_pressed("look_up") && Input.is_action_just_pressed("attack"):
			animation_player.play("attack_up")
			attack()
		elif Input.is_action_pressed("look_down"):
			if(Input.is_action_just_pressed("attack") && not is_on_floor()):
				animation_player.play("attack_down")
				attack()
			else:
				drop()
		elif Input.is_action_just_pressed("attack"):
			if(sprite.flip_h):
				animation_player.play("attack_left")
			else:
				animation_player.play("attack_side")
			attack()


# This is called when an animation finishes playing
# We need to change the animation once the attack finshes
func _on_animation_player_animation_finished(anim_name):
	disable_movement = false
	if anim_name != "idle":
		animation_player.play("idle")

func collide(other):
	if other == null:
		return
		
	var parent = other.get_parent()
	if parent.is_in_group("item"):
		match (parent.type):
			Item.ItemType.ANGEL:
				print_debug("got the angel parasite")
				angel_active = true
				angel_hud.show()
			Item.ItemType.VAMPIRE:
				print_debug("got the vampire parasite")
				vampire_active = true
				vampire_hud.show()
		parent.queue_free()


func _on_animation_player_animation_started(anim_name):
	if anim_name != "idle" and anim_name != "run_right":
		disable_movement = true
		
func take_damage(damage) -> void:
	curr_health -= damage
	if(curr_health <= 0):
		print("Dead")
	print("Did Damage")

func pogo():
	if pogo_countdown > 0:
		return
	
	pogo_countdown = pogo_cooldown_time
	disable_movement = false
	velocity.y = min(velocity.y, pogo_velocity)
	
func drop():
	print_debug("attempt to drop")
	var result = drop_raycast.get_collider()
	if result && result is CollisionObject2D:
		print_debug("Successful raycast")
		result as CollisionObject2D
		if result.is_shape_owner_one_way_collision_enabled(result.get_shape_owners()[0]):
			position.y += 1
