extends Node2D

var enemyTimer = 0
var is_paused := false
@onready var pmenu = $PauseMenu
@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Globals.main_scene = self

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func pauseMenu():
	if is_paused:
		pmenu.hide()
		Engine.time_scale = 1
	else:
		pmenu.show()
		Engine.time_scale = 0
	is_paused = !is_paused

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pauseMenu()
	pass
