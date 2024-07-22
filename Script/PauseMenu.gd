extends Control

var is_paused := false

@onready var camera := get_parent().get_node("Camera2D") # Adjust the path to your Camera2D node if necessary

func _ready():
	self.visible = false # Ensure the pause menu is hidden initially

func _input(event):
	if Input.is_action_just_pressed("esc"):
		is_paused = !is_paused # Toggle the pause state
		self.visible = is_paused
		get_tree().paused = is_paused
		print("test")
	pass
