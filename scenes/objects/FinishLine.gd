extends Node2D



func _on_area_2d_body_entered(body):
	var main = get_node("/root/Main")
	main.victory()
