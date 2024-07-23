extends Node2D
@export var starting_room:bool = true

@export var width_in_tiles:int = 0
@export var height_in_tiles:int = 0
@export var starting_location:Vector2
var totalrooms
var clearCount = 0
signal speakToroom
signal talktotheMaster(roomcleared, maxroom)
# Called when the node enters the scene tree for the first time.
func _ready():
	totalrooms = speakToroom.get_connections().size()
	connectAreas()
	$ColorRect.size.x = 64*width_in_tiles
	$ColorRect.size.y = 64*height_in_tiles
	if starting_room == false:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = true
		enter_room()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enter_room():
	$AnimationPlayer.play("fade_out")
func connectAreas():
	$EnemySpawner.areaInfo.connect(areaCount)
	$EnemySpawner2.areaInfo.connect(areaCount)
	$EnemySpawner3.areaInfo.connect(areaCount)
	$EnemySpawner4.areaInfo.connect(areaCount)
	$EnemySpawner5.areaInfo.connect(areaCount)
	$EnemySpawner6.areaInfo.connect(areaCount)
	$EnemySpawner7.areaInfo.connect(areaCount)
	$EnemySpawner8.areaInfo.connect(areaCount)
	$EnemySpawner9.areaInfo.connect(areaCount)
	$EnemySpawner10.areaInfo.connect(areaCount)
	
func areaCount(clearcounts:int):
	clearCount += 1
	talktotheMaster.emit(clearCount,totalrooms)
