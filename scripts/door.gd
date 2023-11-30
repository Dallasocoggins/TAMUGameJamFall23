extends Node2D

@onready var door_body = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player && body.has_key:
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true);
