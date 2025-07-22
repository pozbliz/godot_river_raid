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
	if get_parent() is Player and area.is_in_group("hazard"):
		var attack = Attack.new()
		attack.attack_damage = 9999
		damage(attack)
		return
	
	if area is HitboxComponent:
		if not area.get_parent().is_in_group("player"):
			return
		
		var attack = Attack.new()
		attack.attack_damage = contact_damage
		area.damage(attack)
