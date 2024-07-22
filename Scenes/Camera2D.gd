extends Camera2D

@onready var player := get_tree().get_first_node_in_group("player")
var previous_position : Vector2

func _ready():
	previous_position = global_position

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	
	# Store the current position before updating
	previous_position = global_position
	
	offset.x = snapped((mouse_pos.x - global_position.x) / (1920.0 / 2.0) * 150, 0.5)
	offset.y = snapped((mouse_pos.y - global_position.y) / (1080.0 / 2.0) * 150, 0.5)
	
	self.global_position = player.global_position
	
	force_update_scroll()

func revert_to_previous_position():
	global_position = previous_position
	force_update_scroll()
