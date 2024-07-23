extends Node2D

var enemyTimer = 0
var is_paused := false
var enemycount
var allroomSpawned : bool = false
@onready var menuhub = $MenuHub/WinMenu
# Called when the node enters the scene tree for the first time.
func _ready():


	pass # Replace with function body.


func _process(delta):
	enemycount = get_tree().get_nodes_in_group("enemy").size()
	
	if allroomSpawned && enemycount <= 0 :
		menuhub.show()#

func _on_room_talktothe_master(roomcleared, maxroom):
	if roomcleared == maxroom:
		allroomSpawned = true
	pass # Replace with function body.
