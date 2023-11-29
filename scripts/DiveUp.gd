class_name DiveUp
extends State

@export var enemy : BasicEnemy
@export var dive_down : DiveDown
@export var move_speed = 500.0
@export var retreat_dist = 900.0
@export var vision_dist = 1500.0

var player : CharacterBody2D
var target
var direction

@export var sprite : Sprite2D

# Called when the node enters the scene tree for the first time.
func _enter():
	#print_debug("Hey1")
	player = get_tree().get_first_node_in_group("player_root")
	target = dive_down.get_target()
	direction = dive_down.get_direction()

	

func _physics_update(delta):
	if !enemy.is_stunned():
		if(enemy.is_on_wall()):
			Transitioned.emit(self, "follow")
		
		var dir = enemy.global_position - target
		
		enemy.velocity = (move_speed * -direction.normalized())
		enemy.velocity.y = - abs(enemy.velocity.y)
		
		if(dir.length() >= retreat_dist and dir.length() <= vision_dist):
			Transitioned.emit(self, "follow")
		elif(dir.length() >= retreat_dist):
			Transitioned.emit(self, "idle")
	else:
		enemy.velocity = Vector2.ZERO
	

func _exit():
	#print_debug("Hey2")
	if(direction.x < 0 and !enemy.is_facing_right()) or (direction.x > 0 and enemy.is_facing_right()):
		enemy.flip_is_facing_right()
	pass

