extends Node2D
class_name HealthComponent


@export var MAX_HEALTH: float = 1.0
var health: float

func _ready() -> void:
	health = MAX_HEALTH


func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		await get_parent().play_death_animation()
