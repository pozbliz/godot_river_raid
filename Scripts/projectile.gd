extends Area2D


var speed: float = 0
var damage: int = 0
var direction: Vector2 = Vector2.ZERO
var sprite_texture: Texture

@onready var color_rect = $ColorRect
@onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	add_to_group("projectile")
	
	if $Sprite2D and sprite_texture:
		$Sprite2D.texture = sprite_texture
		
	_update_collision_shape_to_match_color_rect()

func _process(delta):
	if get_tree().paused:
		return
	position += direction * speed * delta
	
func _update_collision_shape_to_match_color_rect():
	var rect_size = color_rect.size
	var shape = RectangleShape2D.new()
	shape.size = rect_size
	collision_shape.shape = shape
	
func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		var attack = Attack.new()
		attack.attack_damage = damage
		
		area.damage(attack)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
