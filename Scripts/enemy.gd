extends Area2D
class_name Enemy


func _ready() -> void:
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	var screen_rect = get_viewport().get_visible_rect()
	if global_position.x < screen_rect.position.x - 100:
		queue_free()
		print("removing from horizontal")
	if position.y < -100 or position.y > get_viewport().size.y + 100:
		queue_free()
		print("removing from vertical")

func play_death_animation():
	$AnimatedSprite2D.play("death")
	$HitboxComponent/CollisionShape2D.disabled = true
	set_deferred("monitoring", false)
	await $AnimatedSprite2D.animation_finished
	queue_free()
