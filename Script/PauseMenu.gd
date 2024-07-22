extends Control

func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("esc"):
		self.visible = true
		get_tree().paused = true
	pass
