extends Node


func _ready() -> void:
	$Player.fuel_changed.connect(_on_fuel_changed)
	new_game()

func _process(delta: float) -> void:
	pass
	
func new_game():
	$Player.reset_position($PlayerStartPosition.position)
	$Player.show()
	$HUD.show()
	
func game_over():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_fuel_changed(fuel: float):
	$HUD.update_fuel(fuel)
