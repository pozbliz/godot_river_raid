extends Node2D


const SPEED: float = 300
const DIRECTION: Vector2 = Vector2.LEFT

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var velocity: Vector2 = DIRECTION * SPEED
	position += velocity * delta
