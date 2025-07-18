extends CanvasLayer


signal new_game


func _ready() -> void:
	$VBoxContainer/StartGameButton.pressed.connect(_on_start_game_button_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_button_pressed)
	$VBoxContainer/ExitGameButton.pressed.connect(_on_exit_game_button_pressed)

func _process(delta: float) -> void:
	pass

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	hide()
	
func _on_options_button_pressed():
	pass
	
func _on_exit_game_button_pressed():
	get_tree().quit()
