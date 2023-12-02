class_name EnemyAttack
extends State

@export var enemy : BasicEnemy
@export var cooldown = 3.0
@export var attack_range := 400.0
var player : CharacterBody2D
@onready var cooldown_left = cooldown
var attack_over = true

@export var sprite : Sprite2D

@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _enter():
	print_debug("Entered Attack")
	player = get_tree().get_first_node_in_group("Player")
	if attack_over:
		attack_over = false
		cooldown_left = cooldown
		animation_player.play("attack")
		animation_player.queue("RESET")
	
func _update(delta):
	var direction = enemy.global_position - player.global_position
	enemy.velocity.x = 0;
	if(attack_over):
		cooldown_left -= delta
	
	
	if(cooldown_left <= 0 and direction.length() > attack_range):
		Transitioned.emit(self, "follow")
	elif(cooldown_left <= 0):
		if(direction.x < 0 and !enemy.is_facing_right()) or (direction.x > 0 and enemy.is_facing_right()):
			enemy.flip_is_facing_right()
		attack_over = false
		cooldown_left = cooldown
		animation_player.play("attack")
		animation_player.queue("RESET")

func _exit():
	print_debug("Hey2")
	


func _on_animation_player_animation_finished(anim_name):
	attack_over = true

func _on_animation_player_animation_changed(old_name, new_name):
	pass # Replace with function body.
