extends Area2D
class_name HitboxComponent


@export var health_component: HealthComponent
@export var contact_damage: int = 1


func _ready():
	area_entered.connect(_on_hitbox_component_area_entered)

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		
func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		var attack = Attack.new()
		attack.attack_damage = contact_damage
		area.damage(attack)
