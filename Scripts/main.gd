extends Node


@export var fuel_pickup_scene: PackedScene
@export var main_menu_scene: PackedScene

var is_paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
	$FuelSpawnTimer.process_mode = Node.PROCESS_MODE_PAUSABLE
	$WorldRoot.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	$Player.fuel_changed.connect(_on_fuel_changed)
	$FuelSpawnTimer.timeout.connect(_on_fuel_timer_timeout)
	new_game()

func _unhandled_input(event):
	if event.is_action_pressed("open_menu"):
		toggle_pause()
		
func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	$PauseMenu.visible = is_paused

func _process(delta: float) -> void:
	pass
	
func new_game():
	$Player.reset_position($PlayerStartPosition.position)
	$Player.show()
	$HUD.show()
	$FuelSpawnTimer.start()
	
func game_over():
	get_tree().change_scene_to_packed(main_menu_scene)
	
func _spawn_fuel_pickup():
	var fuel_pickup = fuel_pickup_scene.instantiate()
	$WorldRoot.add_child(fuel_pickup)
	var global_position = Vector2(1200, randf_range(150, 450))
	var local_position = $WorldRoot.to_local(global_position)
	fuel_pickup.position = local_position
	fuel_pickup.collected.connect(_on_fuel_pickup_collected)
	
func _on_fuel_pickup_collected(amount: int):
	print("fuel collected")
	$Player.refuel(amount)
	
func _on_fuel_changed(fuel: int):
	$HUD.update_fuel(fuel)
	
func _on_fuel_timer_timeout():
	_spawn_fuel_pickup()
