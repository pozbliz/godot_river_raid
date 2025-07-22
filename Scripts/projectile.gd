extends Area2D


var speed: float = 0
var damage: int = 0
var direction: Vector2 = Vector2.ZERO
var sprite_texture: Texture
var shooter_group: String = ""
var collision_size: Vector2
var projectile_scale: Vector2

@onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	self.area_entered.connect(_on_projectile_area_entered)
	add_to_group("projectile")
	
	$Sprite2D.texture = sprite_texture
	$Sprite2D.scale = projectile_scale
	_update_collision_shape_to_match_sprite()

func _process(delta):
	if get_tree().paused:
		return
	position += direction * speed * delta
	
func _update_collision_shape_to_match_sprite():
	var shape = RectangleShape2D.new()
	shape.size = collision_size
	collision_shape.shape = shape
	
func _on_projectile_area_entered(area):
	if area is HitboxComponent:
		var target = area.get_parent()
		# Dont damage entities in same group (enemy, player)
		if target.is_in_group(shooter_group):
			return
			
		var attack = Attack.new()
		attack.attack_damage = damage
		area.damage(attack)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
