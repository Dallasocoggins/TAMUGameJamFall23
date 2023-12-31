class_name EnemyIdle
extends State

@export var enemy : BasicEnemy
@export var vision_dist = 900.0
@export var min_vision_dist = 100.0
@export var wander_time_max = 5.0
@export var wander_time_min = 1.0
@export var wait_time_max = 3.0
@export var wait_time_min = 0.5
@export var walking_speed = 100.0

var wander_time_left = wander_time_max
var wait_time_left = wait_time_max

var player : CharacterBody2D

@export var ledge_raycast : RayCast2D

@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _enter():
	#print_debug("Hey1")
	player = get_tree().get_first_node_in_group("player_root")
	animation_player.play("idle")
	

	
func _update(delta):
	# print_debug("Hey")
	var player_direction = enemy.global_position - player.global_position
	#print_debug(((player_direction.x > 0 and !enemy.is_facing_right()) or (player_direction.x < 0 and enemy.is_facing_right())))
	#print_debug(player_direction.length())
	if ((player_direction.x > 0 and !enemy.is_facing_right()) or (player_direction.x < 0 and enemy.is_facing_right())) \
	and player_direction.length() <= vision_dist and player_direction.length() >= min_vision_dist:
		Transitioned.emit(self, "follow")
		#print_debug("Hey")

func _physics_update(delta):
	
	#print_debug("wander ", wander_time_left)
	#print_debug("wait ", wait_time_left)
	var direction = 1 if enemy.is_facing_right() else -1
	
	if ledge_raycast:
		var result = ledge_raycast.get_collider()
		if !result:
			enemy.flip_is_facing_right()
	
	if (wander_time_left > 0 && !enemy.is_on_wall()):
		enemy.velocity.x = walking_speed * direction
		wander_time_left -= delta
		#print_debug("velocity ", enemy.velocity.x)
	elif (wait_time_left > 0  && !enemy.is_on_wall()):
		enemy.velocity = Vector2.ZERO
		wait_time_left -= delta
	else:
		enemy.flip_is_facing_right()
		wander_time_left = randf_range(wander_time_min, wander_time_max)
		wait_time_left = randf_range(wait_time_min, wait_time_max)

func _take_damage():
	print_debug("Enemy Damaged during Idle")
	Transitioned.emit(self, "follow")

func _exit():
	#print_debug("Hey2")
	pass
	
	
	
