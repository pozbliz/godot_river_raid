extends Node


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func set_player_position():
	$Player.reposition($PlayerStartPosition)
