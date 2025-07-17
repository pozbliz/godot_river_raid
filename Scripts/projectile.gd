extends Area2D


@export var speed = 400
@export var damage: int = 1
@export var cooldown: float = 0.3
var velocity := Vector2.ZERO
var direction := Vector2.RIGHT

signal enemy_hit

func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	add_to_group("projectile")

func _process(delta):
	position += direction * speed * delta
	
func _on_projectile_body_entered(body):
	enemy_hit.emit()
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
