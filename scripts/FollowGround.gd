class_name FollowGround
extends State

@export var enemy : BasicEnemy
@export var move_speed := 400.0
@export var vision_dist := 1500.0
@export var attack_range := 400.0
var player : CharacterBody2D

@export var sprite : Sprite2D


# Called when the node enters the scene tree for the first time.
func _enter():
	player = get_tree().get_first_node_in_group("player_root")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_update(delta : float):
	if(!player):
		player = get_tree().get_first_node_in_group("player_root")
	var direction = enemy.global_position - player.global_position
	#print_debug(direction.length())
	
	if(direction.length() > vision_dist):
		Transitioned.emit(self, "idle")
	elif(direction.length() < attack_range):
		Transitioned.emit(self, "attack")
	
	if(direction.x < 0):
		enemy.velocity.x = move_speed
	else:
		enemy.velocity.x = -move_speed
	
	if(direction.x < 0 and !enemy.is_facing_right()) or (direction.x > 0 and enemy.is_facing_right()):
		enemy.flip_is_facing_right()
		sprite.scale.x *= -1
	
		
	
	# print_debug(enemy.velocity)
	pass
