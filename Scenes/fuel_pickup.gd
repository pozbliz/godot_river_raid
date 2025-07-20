extends Area2D


const FUEL_AMOUNT: int = 10


signal collected(fuel_amount: int)


func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	pass
	
func _on_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent() is Player:
			collected.emit(FUEL_AMOUNT)
			queue_free()
