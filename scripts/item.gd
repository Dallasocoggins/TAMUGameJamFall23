@tool
extends Node2D

@export var texture: Texture2D
@export var spriteScale = Vector2(1,1)


@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = texture
	sprite.scale = spriteScale
	animation_player.play("bobbing_up_and_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		sprite.texture = texture
		sprite.scale = spriteScale
