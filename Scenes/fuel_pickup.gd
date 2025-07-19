extends Area2D


const FUEL_AMOUNT: int = 10


signal collected(fuel_amount: int)


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	if body is Player:
		collected.emit(FUEL_AMOUNT)
		queue_free()
