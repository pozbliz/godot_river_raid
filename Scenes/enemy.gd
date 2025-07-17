extends Area2D


@export var projectile_scene: PackedScene

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func shoot():
	var shot = projectile_scene.instantiate()
	owner.add_child(shot)
	shot.position = position
