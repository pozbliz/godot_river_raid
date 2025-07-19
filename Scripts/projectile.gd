extends Area2D


@export var speed: int = 400
@export var damage: int = 1
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	add_to_group("projectile")

func _process(delta):
	if get_tree().paused:
		return
	if is_in_group("enemies"):
		direction = Vector2.LEFT
	position += direction * speed * delta
	
func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		var attack = Attack.new()
		attack.attack_damage = damage
		
		area.damage(attack)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
