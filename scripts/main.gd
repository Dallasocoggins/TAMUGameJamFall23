extends Node2D

var in_level = false
var pause_screen = null


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_main_menu()
	
	# I was having an issue where the character jitters when the camera moves.
	# It turns out setting the physics framerate to match the monitor refresh rate fixes the issue.
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate()

func _process(delta):
	if Input.is_action_just_pressed("pause") && in_level:
		# get_tree().quit()
		if pause_screen == null:
			pause()
		else:
			unpause()

func unload_children():
	for node in get_children():
		remove_child(node)

func load_main_menu():
	in_level = false
	unpause()
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
	in_level = true
	unload_children()
	var scene = preload("res://scenes/level/level2.tscn")
	var instance = scene.instantiate()
	instance.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(instance)

func pause():
	get_tree().paused = true
	var scene = preload("res://scenes/menus/pause_menu.tscn")
	pause_screen = scene.instantiate()
	add_child(pause_screen)

func unpause():
	get_tree().paused = false
	remove_child(pause_screen)
	pause_screen = null
