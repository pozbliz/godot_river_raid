extends Area2D


@export var projectile_scene: PackedScene
@export var damage: int = 1
@export var shoot_interval: float = 1.5
@export var projectile_speed: float = 300
@export var projectile_direction: Vector2 = Vector2.LEFT
@export var projectile_texture: Texture
@export var autoshoot: bool = false

var shoot_timer: Timer


func _ready():
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_interval
	shoot_timer.autostart = true
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)

func shoot():
	if projectile_scene == null:
		return
	var shot = projectile_scene.instantiate()
	
	shot.speed = projectile_speed
	shot.damage = damage
	shot.direction = projectile_direction
	shot.sprite_texture = projectile_texture
	
	GameGlobals.projectile_parent.add_child(shot)
	shot.global_position = global_position

func _on_shoot_timer_timeout():
	if autoshoot:
		shoot()
