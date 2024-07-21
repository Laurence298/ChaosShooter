extends CharacterBody2D
class_name Player

@onready var crosshair = $Crosshair
@onready var energy_bar = $CanvasLayer/EnergyBar
#@onready var camera_2d = $Camera2D
#@onready var anim_sprite = $AnimSprite


@onready var sprite_upper = $SpriteUpper
@onready var arm = $Arm
@onready var sprite_lower = $SpriteLower

var heart = {
	"BL": "back_left1",
	"BR": "back_right1", 
	"FL": "front_left1", 
	"FR": "front_left1"
}
var battery = {
	"BL": "back_left2",
	"BR": "back_right2", 
	"FL": "front_left2", 
	"FR": "front_left2"
}

var gun = {
	"BL": "back_left1",
	"BR": "back_right1", 
	"FL": "front_left1", 
	"FR": "front_left1"
}

var blaster = {
	"BL": "back_left2",
	"BR": "back_right2", 
	"FL": "front_left2", 
	"FR": "front_left2"
}

var drill = {
	"B": "back",
	"F": "front"
}

var upgrades = {
"Body": heart, 
"Weapon": gun,
"Legs": drill,
}

var current_arm
var current_body
var current_legs

var vec_to_crosshair

# Bullet info
var playerstats: Player_Status
const BULLET = preload("res://Scenes/bullet.tscn")
const SPEED = 300.0
const MAX_ENERGY:float = 100
var can_fire : bool;
var equiped_Weapon: PowerUp.WeaponType
var energy:float = MAX_ENERGY
var knockBack: float;

var extra_velocity:Vector2 = Vector2(0,0)

func _ready():
	#anim_sprite.play("default")
	equiped_Weapon = PowerUp.WeaponType.SMALL_GUN
	can_fire = true;
	return

func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = Vector2.ZERO
	
	#if extra_velocity.length() < 100:
	#	velocity = direction.normalized() * SPEED
	
	#velocity = direction.normalized() * SPEED
	
	direction = direction.normalized() * SPEED
	
	var vel_dif = direction.dot(extra_velocity.normalized())
	if vel_dif < 0 && extra_velocity.length() > 100:
		direction -= vel_dif*extra_velocity.normalized()
	
	velocity += direction
	
	velocity += extra_velocity
	extra_velocity = extra_velocity.lerp(Vector2.ZERO, delta * 12)
	
	# flips drill legs and body and weapon accorreding to the direction
	if direction.x != 0:
		if direction.x > 1:
			sprite_lower.scale.x = 1
			sprite_upper.animation.play("")
		if direction.x < 1:
			sprite_lower.scale.x = -1
	
	
	
	move_and_slide()
	#self.position = position.round()

func _process(delta):
	crosshair.position = get_local_mouse_position()
	vec_to_crosshair = (crosshair.global_position - self.global_position).normalized()
	
	energy = clamp(energy+10*delta, 0, 100)
	energy_bar.scale.x = energy/MAX_ENERGY
	
	var mouse_pos = get_global_mouse_position()
	#camera_2d.offset.x = round((mouse_pos.x - global_position.x) / (1920.0 / 2.0) * 150)
	#camera_2d.offset.y = round((mouse_pos.y - global_position.y) / (1080.0 / 2.0) * 150)
	
	
	
	if mouse_pos < self.global_position:
		$Rat.scale.x = 1
		$Rat.look_at(mouse_pos)
		$Rat.rotation += deg_to_rad(180)
	else:
		$Rat.scale.x = -1
		$Rat.look_at(mouse_pos)
	#camera_2d.global_position = camera_2d.global_position.round()
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0:
		sprite_upper.play(upgrades["Body"]["FR"])
		arm.play(upgrades["Weapon"]["FR"])
	elif direction.x < 0:
		sprite_upper.play(upgrades["Body"]["FL"])
		arm.play(upgrades["Weapon"]["FL"])
	elif direction.x == 0:
		sprite_upper.stop()
	
func _input(event):
	match equiped_Weapon:
		PowerUp.WeaponType.SMALL_GUN:
			if event.is_action_pressed("shoot") && can_fire:
				FireGunSeting()
				BulletManager.create_bullet(self, BulletManager.CollisionLayer.ENEMY, vec_to_crosshair*1500, 25, self.global_position, playerstats)
				DebugDraw2D.line(self.position, self.position + (vec_to_crosshair * self.global_position.distance_to(crosshair.global_position)), Color.RED, 3, 0.5)
		PowerUp.WeaponType.BIG_GUN:
			if event.is_action_pressed("shoot") && can_fire:
				FireGunSeting()
				BulletManager.shotgun(self, BulletManager.CollisionLayer.ENEMY, vec_to_crosshair*1500, 15, 35, 500, 0,playerstats)
				DebugDraw2D.line(self.position, self.position + (vec_to_crosshair * self.global_position.distance_to(crosshair.global_position)), Color.RED, 3, 0.5)


func FireGunSeting():
	energy -= 100
	can_fire = false
	$FireRateTimer.start()
	extra_velocity += vec_to_crosshair * -1 * knockBack
	$AudioStreamPlayer.play()
	#BulletManager.create_bullet(self, BulletManager.CollisionLayer.ENEMY, vec_to_crosshair*1500, 25, self.global_position)

func set_combatStatus(player_stat: Player_Status):
	playerstats = player_stat
	$FireRateTimer.wait_time = player_stat.firerate
	knockBack = player_stat.KnockBackStreagth
	


func _on_fire_rate_timer_timeout():
	can_fire = true
