class_name TryToHeal
extends MyHitBox

func _on_area_entered(other) -> void:
	if owner.has_method("vampire_heal"):
		owner.vampire_heal(damage)
	else:
		print("Did not find vampre_heal method in " + owner.get_class())
