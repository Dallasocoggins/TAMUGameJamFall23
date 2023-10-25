extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# I was having an issue where the character jitters when the camera moves.
	# It turns out setting the physics framerate to match the monitor refresh rate fixes the issue.
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
