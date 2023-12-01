extends TextureButton


func _on_pressed():
	var main = get_node("/root/Main")
	main.load_main_menu()
