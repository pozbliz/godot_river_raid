extends Area2D


@export var projectile_scene: PackedScene
@export var damage: int = 1
@export var shoot_interval: float = 1.5

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
	owner.add_child(shot)
	shot.position = position

func _on_shoot_timer_timeout():
	shoot()

	var projectile = projectile_scene.instantiate()
	owner.add_child(projectile)
	projectile.global_position = get_parent().global_position
