class_name MyHurtBox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 0x20

	
func _on_area_entered(hitbox: MyHitBox) -> void:
	if hitbox == null:
		return
	
	print_debug("hitbox hits hurtbox")
	
	if owner.has_method("take_damage"):
		print_debug("Did " + str(hitbox.damage) + " damage")
		owner.take_damage(hitbox.damage)


