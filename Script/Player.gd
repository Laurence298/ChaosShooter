extends CharacterBody2D
class_name Player

@onready var crosshair = $Crosshair
@onready var health_bar = $CanvasLayer/health_bar
@onready var heat_bar = $CanvasLayer/heat_bar
@onready var color_rect_3 = $CanvasLayer/ColorRect3


#@onready var camera_2d = $Camera2D
#@onready var anim_sprite = $AnimSprite

#region animation variables
@onready var sprite_upper = $SpriteUpper
@onready var arm = $Arm
@onready var sprite_lower = $SpriteLower

var is_paused := false
var heart = {
	"BL": "back_left1",
	"BR": "back_right1", 
	"FL": "front_left1", 
	"FR": "front_right1"
}
var battery = {
	"BL": "back_left2",
	"BR": "back_right2", 
	"FL": "front_left2", 
	"FR": "front_right2"
}

var gun = {
	"BL": "back_left1",
	"BR": "back_right1", 
	"FL": "front_left1", 
	"FR": "front_right1"
}

var blaster = {
	"BL": "back_left2",
	"BR": "back_right2", 
	"FL": "front_left2", 
	"FR": "front_right2"
}

var drill = {
	"B": "back",
	"F": "front"
}
var body_upgrades = [heart, battery]
var arm_upgrades = [gun, blaster]
var leg_upgrades = [drill]

var upgrades = {
"Body": heart, 
"Weapon": gun,
"Legs": drill,
}

#endregion
#body modification Status

signal  WeaponFired
signal  on_health_changed(health, whoattacked)
signal  on_heat_changed(heat)
const MAX_HEALTH : float = 100
var health: float = MAX_HEALTH

const max_heat_gauge: float= 100
var heat_gauge: float = 0
#body modification


@export var curretbodymodification: PowerUp.body_modification
var vec_to_crosshair: Vector2

# Bullet info and weapon
var playerstats: Player_Status
const BULLET = preload("res://Scenes/bullet.tscn")
const SPEED = 300.0
var can_fire : bool;
@export var equiped_Weapon: PowerUp.WeaponType
var knockBack: float;

var extra_velocity:Vector2 = Vector2(0,0)

func _ready():
	#anim_sprite.play("default")
	on_health_changed.emit(health)
	on_heat_changed.emit(heat_gauge)
	randomize_stats();
	can_fire = true;
	sprite_upper.play(upgrades["Body"]["FR"])
	arm.play(upgrades["Weapon"]["FR"])
	return

func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2(0,0):
		velocity += Vector2(1, 1)
	else:
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
	move_and_slide()
	#self.position = position.round()

func _process(delta):
	crosshair.position = get_local_mouse_position()
	vec_to_crosshair = (crosshair.global_position - self.global_position).normalized()
	
	
	health_bar.scale.x = health/MAX_HEALTH
	
	if upgrades.Body == battery or heat_gauge != 0:
		heat_bar.visible = true
		color_rect_3.visible = true
	else: 
		heat_bar.visible = false
		color_rect_3.visible = false
	if heat_gauge > 60:
		$CanvasLayer/heat_bar/GPUParticles2D.emitting = true
	else:
		$CanvasLayer/heat_bar/GPUParticles2D.emitting = false
	heat_bar.scale.x = heat_gauge/max_heat_gauge
	
	match upgrades.Body:
		battery:
			heat_gauge = clamp(heat_gauge - 5 *delta, 0, max_heat_gauge)
		heart:
			heat_gauge = clamp(heat_gauge - 10 *delta, 0, max_heat_gauge)
	health = clamp(health + 6 * delta, 0, MAX_HEALTH)
	
	var mouse_pos = get_global_mouse_position()
	#camera_2d.offset.x = round((mouse_pos.x - global_position.x) / (1920.0 / 2.0) * 150)
	#camera_2d.offset.y = round((mouse_pos.y - global_position.y) / (1080.0 / 2.0) * 150)
	
	
	

	#camera_2d.global_position = camera_2d.global_position.round()
	
	# flips drill legs and body and weapon accorreding to the direction
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.y < 0:
		if direction.x > 0:
			sprite_upper.play(upgrades["Body"]["BR"])
			arm.play(upgrades["Weapon"]["BR"])
			arm.z_index = 1
			if mouse_pos < self.global_position:
				arm.scale.x = -1
				arm.look_at(mouse_pos)
				arm.rotation += deg_to_rad(180)
			else:
				arm.scale.x = 1
				arm.look_at(mouse_pos)
		elif direction.x < 0:
			sprite_upper.play(upgrades["Body"]["BL"])
			arm.play(upgrades["Weapon"]["BL"])
			arm.z_index = 1
			if mouse_pos < self.global_position:
				arm.scale.x = 1
				arm.look_at(mouse_pos)
				arm.rotation += deg_to_rad(180)
			else:
				arm.scale.x = -1
				arm.look_at(mouse_pos)
		else:
			sprite_upper.play(upgrades["Body"]["BL"])
			arm.play(upgrades["Weapon"]["BL"])
			arm.z_index = 1
			if mouse_pos < self.global_position:
				arm.scale.x = 1
				arm.look_at(mouse_pos)
				arm.rotation += deg_to_rad(180)
			else:
				arm.scale.x = -1
				arm.look_at(mouse_pos)
	else:
		if sprite_upper.animation == (upgrades["Body"]["BL"]):
			sprite_upper.play(upgrades["Body"]["FL"])
			arm.play(upgrades["Weapon"]["FL"])
			arm.z_index = 0
		if sprite_upper.animation == (upgrades["Body"]["BR"]):
			sprite_upper.play(upgrades["Body"]["FR"])
			arm.play(upgrades["Weapon"]["FR"])
			arm.z_index = 0
		if direction.x > 0:
			sprite_lower.scale.x = 1
			sprite_upper.play(upgrades["Body"]["FR"])
			arm.play(upgrades["Weapon"]["FR"])
			arm.z_index = 0
			if mouse_pos < self.global_position:
				arm.scale.x = -1
				arm.look_at(mouse_pos)
				arm.rotation += deg_to_rad(180)
			else:
				arm.scale.x = 1
				arm.look_at(mouse_pos)
		elif direction.x < 0:
			sprite_lower.scale.x = -1
			sprite_upper.play(upgrades["Body"]["FL"])
			arm.play(upgrades["Weapon"]["FL"])
			arm.z_index = 0
			if mouse_pos < self.global_position:
				arm.scale.x = 1
				arm.look_at(mouse_pos)
				arm.rotation += deg_to_rad(180)
			else:
				arm.scale.x = -1
				arm.look_at(mouse_pos)
		if direction.x == 0:
			if sprite_upper.animation == (upgrades["Body"]["FR"]):
				if mouse_pos < self.global_position:
					arm.scale.x = -1
					arm.look_at(mouse_pos)
					arm.rotation += deg_to_rad(180)
				else:
					arm.scale.x = 1
					arm.look_at(mouse_pos)
			if sprite_upper.animation == (upgrades["Body"]["FL"]):
				if mouse_pos < self.global_position:
					arm.scale.x = 1
					arm.look_at(mouse_pos)
					arm.rotation += deg_to_rad(180)
				else:
					arm.scale.x = -1
					arm.look_at(mouse_pos)
func _input(event):
	match equiped_Weapon:
		PowerUp.WeaponType.SMALL_GUN:
			if event.is_action_pressed("shoot") && can_fire:
				WeaponFired.emit()
				FireGunSeting()
				BulletManager.create_bullet(self, BulletManager.CollisionLayer.ENEMY, vec_to_crosshair*1500, 25, self.global_position, playerstats)
				DebugDraw2D.line(self.position, self.position + (vec_to_crosshair * self.global_position.distance_to(crosshair.global_position)), Color.RED, 3, 0.5)
		PowerUp.WeaponType.BIG_GUN:
			if event.is_action_pressed("shoot") && can_fire:
				WeaponFired.emit()
				FireGunSeting()
				BulletManager.shotgun(self, BulletManager.CollisionLayer.ENEMY, vec_to_crosshair*1500, 15, 35, 500, 0,playerstats)
				DebugDraw2D.line(self.position, self.position + (vec_to_crosshair * self.global_position.distance_to(crosshair.global_position)), Color.RED, 3, 0.5)

func Body_modification(curretbodymodification: PowerUp.body_modification):
	match curretbodymodification:
		PowerUp.body_modification.POWERSOURCE:
			print("powersource")
			#logic to change the body parts
		PowerUp.body_modification.HEART:
			print("Heart")
			#logic to change the body parts

func FireGunSeting():
	can_fire = false
	if upgrades.Weapon == gun:
		$FireRateTimerGun.start()
	if upgrades.Weapon == blaster:
		$FireRateTimerBlaster.start()
	extra_velocity += vec_to_crosshair * -1 * knockBack
	$AudioStreamPlayer.play()
	#BulletManager.create_bullet(self, BulletManager.CollisionLayer.ENEMY, vec_to_crosshair*1500, 25, self.global_position)

func set_combatStatus(player_stat: Player_Status):
	playerstats = player_stat
	if(playerstats.body_modification != PowerUp.body_modification.NOMODIFICATION):
		curretbodymodification = playerstats.body_modification
		setup_body_upgrades(curretbodymodification)
	if(playerstats.weapon_Type != PowerUp.WeaponType.NOWEAPON):
		$FireRateTimerGun.wait_time = playerstats.firerate
		knockBack = playerstats.KnockBackStreagth
		equiped_Weapon = playerstats.weapon_Type
		setup_weapon_upgrades(equiped_Weapon)


func setup_weapon_upgrades(equiped_Weapon):
	match equiped_Weapon:
		PowerUp.WeaponType.SMALL_GUN:
			upgrades.Weapon = gun
		PowerUp.WeaponType.BIG_GUN:
			upgrades.Weapon = blaster
func setup_body_upgrades(curretbodymodification):
	match curretbodymodification:
		PowerUp.body_modification.HEART:
			print("heart")
			upgrades.Body = heart
		PowerUp.body_modification.POWERSOURCE:
			upgrades.Body = battery
func randomize_stats():
	var randomstats = Player_Status.new()
	var randbod : int = randi_range(0,1)
	randomstats.weapon_Type = randi_range(0,1)
	randomstats.body_modification = randi_range(0,1)
	randomstats.bullet_size = Vector2.ONE
	randomstats.enemyKnockBackStreangth = randi_range(100, 200)
	randomstats.damage = randi_range(8, 15)
	randomstats.firerate = randf_range(0.3,0.8)
	randomstats.KnockBackStreagth = randi_range(100, 200)
	set_combatStatus(randomstats)
	


func takeDamage(damage, whoattacked):
		health = clamp(health - damage, 0 ,MAX_HEALTH)
		on_health_changed.emit(health, whoattacked)
		if(health <= 0):
			hide()
func hit(hitevent:HitEvent):
	takeDamage(hitevent.damage, "soldier")
	return
func _on_fire_rate_timer_timeout():
	can_fire = true



func _on_weapon_fired():
	match curretbodymodification:
		PowerUp.body_modification.HEART:
			health = clamp(health -10, 0 ,MAX_HEALTH)
			print("heart hurt")
			on_health_changed.emit(health, "player")
		PowerUp.body_modification.POWERSOURCE:
			match upgrades.Weapon:
				blaster:
					heat_gauge = clamp(heat_gauge +20, 0 ,max_heat_gauge)
					print("fire hurt")
					on_heat_changed.emit(heat_gauge)
				gun:
					heat_gauge = clamp(heat_gauge +10, 0 ,max_heat_gauge)
					print("fire hurt")
					on_heat_changed.emit(heat_gauge)
				_:
					print("unknown gun")


func _on_recover_health_timeout():
	health = clamp(health +1, 0 ,MAX_HEALTH)
	on_health_changed.emit(health)


func _on_heat_cooldown_timeout():
	heat_gauge = clamp(heat_gauge -1, 0 ,max_heat_gauge)
	on_heat_changed.emit(heat_gauge)
