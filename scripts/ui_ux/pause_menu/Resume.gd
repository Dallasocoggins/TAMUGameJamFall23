extends TextureButton


func _on_pressed():
	var main = get_node("/root/Main")
	main.unpause()
