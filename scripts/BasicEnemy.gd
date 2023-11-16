class_name BasicEnemy
extends CharacterBody2D

@export var health_points = 100
@export var attack_range := 400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
	
func take_damage(damage) -> void:
	health_points -= damage
	if(health_points <= 0):
		print("Dead")
	print("Did Damage")

