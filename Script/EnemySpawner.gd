extends Node2D

const ENEMY = preload("res://Scenes/Enemy.tscn")
const RANGEDENEMY = preload("res://Scenes/RangedEnemy.tscn")
@export var maxspawnedEnemy: int = 3
@export var enemycount: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if(enemycount <= maxspawnedEnemy):
		print("spawn")
		var randiEnemy = randi_range(1,4)
		var new_enemy = null
		enemycount += 1
		if(randiEnemy % 2 == 0):
			new_enemy = ENEMY.instantiate()
		else:
			new_enemy = RANGEDENEMY.instantiate()
		new_enemy.global_position = self.global_position
		new_enemy.modulate = Color.from_hsv(randf(), 1.0 , 1.0)
		new_enemy.position = self.global_position
		get_tree().root.add_child(new_enemy)




func _on_area_2d_body_entered(body):
	if body.is_in_group("player") :
		$Timer.autostart = true
		$Timer.start()
		print("realease the beast")

