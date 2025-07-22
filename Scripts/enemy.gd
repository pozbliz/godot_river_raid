extends Area2D
class_name Enemy


func _ready() -> void:
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	pass

func play_death_animation():
	$AnimatedSprite2D.play("death")
	$HitboxComponent/CollisionShape2D.disabled = true
	set_deferred("monitoring", false)
	await $AnimatedSprite2D.animation_finished
	queue_free()
