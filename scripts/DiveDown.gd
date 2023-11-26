class_name DiveDown
extends State

@export var enemy : BasicEnemy
@export var move_speed = 500.0
@export var min_diving_height = 200.0

var player : CharacterBody2D
var target
var direction

@export var sprite : Sprite2D

# Called when the node enters the scene tree for the first time.
func _enter():
	print_debug("Hey1")
	player = get_tree().get_first_node_in_group("player_root")
	target = player.global_position
	print_debug(target)
	
	direction = enemy.global_position - target
	if(direction.y <= min_diving_height):
		Transitioned.emit(self, "diveup")

	if(direction.x < 0 and !enemy.is_facing_right()) or (direction.x > 0 and enemy.is_facing_right()):
		enemy.flip_is_facing_right()
		sprite.scale.x *= -1

	

func _physics_update(delta):
	if !enemy.is_stunned():
		if(enemy.is_on_wall()):
			Transitioned.emit(self, "diveup")
			
		var dir = enemy.global_position - target
		print_debug("target ", target)
		print_debug( "Down", direction)
		
		enemy.velocity = move_speed * -direction.normalized()
		
		if(dir.x < 0 and !enemy.is_facing_right()) or (dir.x > 0 and enemy.is_facing_right()):
			# print_debug(direction.length())
			Transitioned.emit(self, "diveup")
	else:
		enemy.velocity = Vector2.ZERO


func _exit():
	print_debug("Hey2")
	pass

func get_target():
	return target
	
func get_direction():
	return direction
