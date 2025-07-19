extends Area2D
class_name Enemy


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func play_death_animation():
	$HitboxComponent/CollisionShape2D.disabled = true
	set_deferred("monitoring", false)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()
