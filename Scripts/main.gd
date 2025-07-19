extends Node


@export var fuel_pickup_scene: PackedScene
@export var main_menu_scene: PackedScene
@export var enemy_ship_scene: PackedScene
@export var enemy_helicopter_scene: PackedScene
@export var enemy_jet_scene: PackedScene
@export var enemy_bridge_scene: PackedScene

var is_paused: bool = false
var screen_size
var enemy_scenes = {}
var enemy_spawn_locations = {
		"ship": func() -> Vector2:
			return Vector2(screen_size.x + 100, randf_range(150, screen_size.y - 150)),
			
		"helicopter": func() -> Vector2:
			return Vector2(screen_size.x + 100, randf_range(50, screen_size.y - 50)),

		"jet": func() -> Vector2:
			var y = -50 if randf() < 0.5 else screen_size.y + 50
			return Vector2(screen_size.x / 2, y),

		"bridge": func() -> Vector2:
			return Vector2(screen_size.x + 100, screen_size.y / 2),
	}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
	$WorldRoot.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	$Player.fuel_changed.connect(_on_fuel_changed)
	
	screen_size = get_viewport().size
	
	var enemy_scenes = {
		"ship": enemy_ship_scene,
		"helicopter": enemy_helicopter_scene,
		"jet": enemy_jet_scene,
		"bridge": enemy_bridge_scene,
	}
	$SpawnScheduleManager.start()
	$SpawnScheduleManager.spawn_requested.connect(_on_spawn_schedule_manager_spawn_requested)
	
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
	
func game_over():
	get_tree().change_scene_to_packed(main_menu_scene)
	
func spawn_fuel_pickup():
	var fuel_pickup = fuel_pickup_scene.instantiate()
	$WorldRoot.add_child(fuel_pickup)
	var global_position = Vector2(1200, randf_range(150, 450))
	var local_position = $WorldRoot.to_local(global_position)
	fuel_pickup.position = local_position
	fuel_pickup.collected.connect(_on_fuel_pickup_collected)
	
func spawn_enemy(type: String):
	print("spawn enemy type:", type)
	var enemy = enemy_scenes[type].instantiate()
	$WorldRoot.add_child(enemy)
	enemy.add_to_group("enemies")
	enemy.position = get_enemy_spawn_location(type)
	print("spawning enemy of type %s at position %s" % [type, enemy.position])
	
func get_enemy_spawn_location(type: String) -> Vector2:
	if enemy_spawn_locations.has(type):
		return enemy_spawn_locations[type].call()
	else:
		return Vector2.ZERO
	
func _on_fuel_pickup_collected(amount: int):
	$Player.refuel(amount)
	
func _on_fuel_changed(fuel: int):
	$HUD.update_fuel(fuel)
	
func _on_spawn_schedule_manager_spawn_requested(type: String):
	print("spawn requested: ", type)
	if enemy_scenes.has(type):
		spawn_enemy(type)
	elif type == "fuel":
		spawn_fuel_pickup()
	else:
		print("type not found")
		print(enemy_scenes)
