extends Node


@export var fuel_pickup_scene: PackedScene
@export var main_menu_scene: PackedScene
@export var enemy_ship_scene: PackedScene
@export var enemy_helicopter_scene: PackedScene
@export var enemy_jet_scene: PackedScene
@export var enemy_bridge_scene: PackedScene

@onready var segment_scene = preload("res://Scenes/river_segment.tscn")

var is_paused: bool = false
var screen_size
var enemy_scenes = {}
var enemy_spawn_locations = {
		"ship": func() -> Vector2:
			return Vector2(screen_size.x + 100, randf_range(150, screen_size.y - 150)),
			
		"helicopter": func() -> Vector2:
			return Vector2(screen_size.x + 100, randf_range(50, screen_size.y - 50)),

		"jet": func() -> Vector2:
			var y = screen_size.y + 50
			return Vector2(screen_size.x / 2, y),

		"bridge": func() -> Vector2:
			return Vector2(screen_size.x + 100, screen_size.y / 2 - 100),
	}
var last_end_points: Array
var last_end_top: Vector2
var last_end_bottom: Vector2
var segments: Array = []
var segment_count: int = 0
var died = false


func _ready() -> void:
	GameGlobals.projectile_parent = $ProjectileRoot
	process_mode = Node.PROCESS_MODE_ALWAYS
	$PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
	$WorldRoot.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	$Player.fuel_changed.connect(_on_fuel_changed)
	
	screen_size = get_viewport().size
	
	enemy_scenes = {
		"ship": enemy_ship_scene,
		"helicopter": enemy_helicopter_scene,
		"jet": enemy_jet_scene,
		"bridge": enemy_bridge_scene,
	}
	$SpawnScheduleManager.start()
	$SpawnScheduleManager.spawn_requested.connect(_on_spawn_schedule_manager_spawn_requested)
	$Player.player_died.connect(_on_player_died)
	
	new_game()

func _unhandled_input(event):
	if event.is_action_pressed("open_menu"):
		toggle_pause()
		
func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	$PauseMenu.visible = is_paused

func _process(delta: float) -> void:
	if len(segments) < 10:
		generate_segments()
	else:
		delete_segment()
	
func new_game():
	var segment = create_segment()
	last_end_points = segment.create_first_segment()
	segment.global_position = Vector2.ZERO
	last_end_top = last_end_points[0]
	last_end_bottom = last_end_points[1]
	$Player.reset_position($PlayerStartPosition.position)
	$Player.show()
	$HUD.show()
	died = false
	
func _on_player_died():
	if died:
		return
	died = true
	get_tree().change_scene_to_packed(main_menu_scene)
	
func spawn_fuel_pickup():
	var fuel_pickup = fuel_pickup_scene.instantiate()
	$WorldRoot.add_child(fuel_pickup)
	var global_position = Vector2(1200, randf_range(200, 400))
	var local_position = $WorldRoot.to_local(global_position)
	fuel_pickup.position = local_position
	fuel_pickup.collected.connect(_on_fuel_pickup_collected)
	
func spawn_enemy(type: String):
	var enemy = enemy_scenes[type].instantiate()
	$WorldRoot.add_child(enemy)
	enemy.add_to_group("enemy")
	var global_position = get_enemy_spawn_location(type)
	enemy.position = $WorldRoot.to_local(global_position)
	
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
	if enemy_scenes.has(type):
		spawn_enemy(type)
	if type == "fuel":
		spawn_fuel_pickup()
	
func generate_segments():
	var new_segment = create_segment()
	new_segment.global_position = Vector2(screen_size.x, 0)
	var new_top = new_segment.generate_new_top_endpoint(last_end_top)
	var new_bottom = new_segment.generate_new_bottom_endpoint(last_end_bottom)

	new_segment.create_top_bank(last_end_top, new_top)
	new_segment.create_bottom_bank(last_end_bottom, new_bottom)
	new_segment.create_river(last_end_top, new_top, last_end_bottom, new_bottom)

	#print("last_end_top: ", last_end_top)
	#print("last_end_bottom: ", last_end_bottom)
	#print("new_top: ", new_top)
	#print("new_bottom: ", new_bottom)

	last_end_top = new_top
	last_end_bottom = new_bottom
	
func create_segment():
	var segment = segment_scene.instantiate()
	$WorldRoot.add_child(segment)
	segment_count += 1
	segments.append([segment, segment_count])
	#print("created segment: ", segment_count)
	return segment
	
func delete_segment():
	var segment_node = segments[0][0]
	var segment_index = segments[0][1]
	if segment_node.global_position.x < segment_index * -screen_size.x:
		var segment_to_delete = segments.pop_front()
		segment_to_delete[0].queue_free()
		#print("deleted segment: ", segment_index)
