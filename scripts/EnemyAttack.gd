class_name EnemyAttack
extends State

@export var enemy : CharacterBody2D
@export var cooldown = 1.0
var player : CharacterBody2D
var cooldown_left = cooldown
var attack_over = false

@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _enter():
	print_debug("Entered Attack")
	player = get_tree().get_first_node_in_group("Player")
	animation_player.play("attack")
	
func _update(delta):
	if(attack_over):
		cooldown_left -= delta
	
	if(cooldown_left <= 0):
		Transitioned.emit(self, "follow")

func _exit():
	print_debug("Hey2")
	


func _on_animation_player_animation_finished(anim_name):
	attack_over = true
