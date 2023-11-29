class_name PlayerPogoHitBox
extends MyHitBox

func _on_area_entered(other) -> void:
	if owner.has_method("pogo"):
		owner.pogo()
	else:
		print("Did not find pogo method in " + owner.get_class())
