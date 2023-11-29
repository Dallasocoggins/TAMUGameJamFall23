class_name BasicEnemy
extends CharacterBody2D

@export var health_points = 100
@export var attack_range := 400.0
@export var start_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true

@onready var sm = $StateMachine
@onready var sprite = $Sprite2D
@export var stunned_time = 1.0
var stun_time_left = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_stunned()):
		stun_time_left -= delta
		print_debug("Stun time: ", stun_time_left)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
	
func take_damage(damage) -> void:
	stun_time_left = stunned_time
	print_debug("Stun time: ", is_stunned())
	print_debug("Stun time: ", stun_time_left)
	
	health_points -= damage
	if(health_points <= 0):
		print("Dead")
		queue_free()
	print("Did Damage")
	sm._take_damage()

func is_facing_right() -> bool:
	return facing_right

func flip_is_facing_right():
	facing_right = !facing_right
	sprite.scale.x *= -1

func is_stunned() -> bool:
	return stun_time_left > 0
