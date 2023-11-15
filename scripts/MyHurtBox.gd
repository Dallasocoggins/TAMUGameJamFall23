class_name MyHurtBox
extends Area2D

func _init() -> void:
	area_entered.connect(_on_area_entered)

	
func _on_area_entered(other) -> void:
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

