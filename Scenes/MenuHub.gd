extends CanvasLayer
@onready var pmenu = $PauseMenu
@onready var dmenu = $DeathMenu
@onready var wmenu = $WinMenu

var is_paused := false
# Called when the node enters the scene tree for the first time.
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


func _on_player_on_health_changed(health):
	pass # Replace with function body.


func _on_player_on_heat_changed(heat):
	pass # Replace with function body.
