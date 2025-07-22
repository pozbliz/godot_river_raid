# MovementComponent.gd
extends Node

@export var speed: float = 100.0
@export var direction: Vector2 = Vector2.ZERO
@export var patrol: bool = false
@export var patrol_radius: float = 30.0
@export var patrol_pause_time: float = 2.0

var start_position: Vector2
var target_position: Vector2
var is_waiting: bool = false
var wait_timer: float = 0.0

func _process(delta: float) -> void:
	if patrol:
		handle_patrol(delta)
	else:
		handle_straight_movement(delta)
	
func handle_straight_movement(delta: float):
	if direction == Vector2.ZERO:
		return
	var parent = get_parent()
	if parent and parent is Node2D:
		parent.position += direction.normalized() * speed * delta
		
func handle_patrol(delta: float):
	if is_waiting:
		wait_timer -= delta
		if wait_timer <= 0:
			is_waiting = false
			pick_new_patrol_target()
		return
	
	var parent = get_parent()
	if not parent or not parent is Node2D:
		return

	var current_pos = parent.global_position
	var to_target = target_position - current_pos
	
	if to_target.length() < 5.0:
		is_waiting = true
		wait_timer = patrol_pause_time
	else:
		var movement = to_target.normalized() * speed * delta
		parent.global_position += movement
	
func pick_new_patrol_target():
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * randf() * patrol_radius
	target_position = start_position + offset
