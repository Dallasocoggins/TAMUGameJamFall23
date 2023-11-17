class_name MyHurtBox
extends Area2D

func _init() -> void:
	pass

	
func _on_area_entered(other) -> void:
	print_debug("Why")
	print_debug(other.owner.name)
	if other == null:
		return
	
	if other is MyHitBox:
		other as MyHitBox
		
		print_debug("hitbox hits hurtbox")
		
		if owner.has_method("take_damage"):
			print_debug("Did " + str(other.damage) + " damage")
			owner.take_damage(other.damage)
	elif owner.has_method("collide"):
		owner.collide(other)

