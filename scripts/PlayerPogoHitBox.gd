class_name PlayerPogoHitBox
extends TryToHeal

func _on_area_entered(other) -> void:
	super._on_area_entered(other)
	if owner.has_method("pogo"):
		owner.pogo()
	else:
		print("Did not find pogo method in " + owner.get_class())
