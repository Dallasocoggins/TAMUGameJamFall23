extends Node2D

@onready var controller_background = $CanvasLayer/ControllerBackground
@onready var keyboard_background = $CanvasLayer/KeyboardBackground

func _ready():
	select_controller()

func select_controller():
	controller_background.show()
	keyboard_background.hide()

func select_keyboard():
	controller_background.hide()
	keyboard_background.show()
