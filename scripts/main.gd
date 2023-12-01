extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()
	
	# I was having an issue where the character jitters when the camera moves.
	# It turns out setting the physics framerate to match the monitor refresh rate fixes the issue.
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

func unload_children():
	for node in get_children():
		remove_child(node)

func load_main_menu():
	unload_children()
	var scene = preload("res://scenes/menus/main_menu.tscn")
	var instance = scene.instantiate()
	add_child(instance)

func load_controls():
	unload_children()
	var scene = preload("res://scenes/menus/controls.tscn")
	var instance = scene.instantiate()
	add_child(instance)

func load_credits():
	unload_children()
	var scene = preload("res://scenes/menus/credits.tscn")
	var instance = scene.instantiate()
	add_child(instance)

func load_level():
	unload_children()
	var scene = preload("res://scenes/level/level2.tscn")
	var instance = scene.instantiate()
	add_child(instance)
