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

func _on_player_on_health_changed(health, whoattacked):
	if health == 0 and whoattacked == "dog":
		dmenu._on_dog_death()
		dmenu.show()
		Engine.time_scale = 0
	elif health == 0 and whoattacked == "soldier":
		dmenu._on_gun_death()
		dmenu.show()
		Engine.time_scale = 0
	elif health < 1:
		dmenu.show()
		Engine.time_scale = 0 # Replace with function body.
	pass

func _on_player_on_heat_changed(heat):
	if heat == 100:
		dmenu._on_heat_death()
		dmenu.show()
		Engine.time_scale = 0
	pass # Replace with function body.
