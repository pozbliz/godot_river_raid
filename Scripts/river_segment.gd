extends Node2D


const DEFAULT_RIVER_WIDTH: float = 300.0
const MIN_RIVER_WIDTH: float = 300
const MIN_DISTANCE_FROM_EDGE: float = 50.0
const MAX_ANGLE: float = 5.0

var screen_size
var segment_length: float


func _ready() -> void:
	screen_size = get_viewport().size
	segment_length = screen_size.x
	
func _process(delta):
	pass
		
func create_first_segment():
	# First segment will be straight
	var start_point_top = Vector2(0, (screen_size.y / 2) - (DEFAULT_RIVER_WIDTH / 2))
	var start_point_bottom = Vector2(0, (screen_size.y / 2) + (DEFAULT_RIVER_WIDTH / 2))
	
	var end_point_top = Vector2(screen_size.x, start_point_top.y)
	var end_point_bottom = Vector2(screen_size.x, start_point_bottom.y)
	
	create_top_bank(start_point_top, end_point_top)
	create_bottom_bank(start_point_bottom, end_point_bottom)
	create_river(start_point_top, end_point_top, start_point_bottom, end_point_bottom)
	
	return [end_point_top, end_point_bottom]
	
func create_top_bank(start_point: Vector2, end_point: Vector2) -> void:
	var top_bank = Polygon2D.new()
	
	# Create polygon points: river edge + screen edges
	var points = PackedVector2Array()
	points.append(start_point)                # Start of river edge
	points.append(end_point)                  # End of river edge  
	points.append(Vector2(end_point.x, 0))    # Top right corner of screen
	points.append(Vector2(start_point.x, 0))  # Top left corner of screen
	
	top_bank.polygon = points
	top_bank.color = Color.GREEN
	add_child(top_bank) 
	
	#print("top points: ", points)
	
	_create_top_collision(points)
	
func _create_top_collision(points: PackedVector2Array) -> void:
	# Add collision for top bank
	var area = Area2D.new()
	var collision = CollisionPolygon2D.new()
	
	collision.polygon = points
	area.add_child(collision)
	area.add_to_group("hazard")
	add_child(area)
	
func create_bottom_bank(start_point: Vector2, end_point: Vector2):
	var bottom_bank = Polygon2D.new()
	
	# Create polygon points: river edge + screen edges
	var points = PackedVector2Array()
	points.append(start_point)                            # Start of river edge
	points.append(end_point)                              # End of river edge
	points.append(Vector2(end_point.x, screen_size.y))    # Bottom right corner 
	points.append(Vector2(start_point.x, screen_size.y))  # Bottom left corner
	 
	bottom_bank.polygon = points
	bottom_bank.color = Color.GREEN
	add_child(bottom_bank)
	
	#print("bottom points: ", points)
	
	_create_bottom_collision(points)
	
func _create_bottom_collision(points: PackedVector2Array) -> void:
	# Add collision for bottom bank
	var area = Area2D.new()
	var collision = CollisionPolygon2D.new()
	
	collision.polygon = points
	area.add_child(collision)
	area.add_to_group("hazard")
	add_child(area)
	
func create_river(
		start_point_top: Vector2, 
		end_point_top: Vector2, 
		start_point_bottom: Vector2, 
		end_point_bottom: Vector2
	):
	var river = Polygon2D.new()
	
	# Create polygon points: river edge + screen edges
	var points = PackedVector2Array()
	points.append(start_point_top)      # Top left of river
	points.append(end_point_top)        # Top right of river  
	points.append(end_point_bottom)     # Bottom right of river
	points.append(start_point_bottom)   # Bottom left of river
	
	river.polygon = points
	river.color = Color.DARK_BLUE
	add_child(river)
	
	#print("river points: ", points)

func generate_new_top_endpoint(previous_end_top: Vector2) -> Vector2:
	var start_point_top: Vector2 = previous_end_top
	var end_point_top: Vector2
	
	var angle_degrees_top = randf_range(-MAX_ANGLE, MAX_ANGLE)
	var angle_radians_top = deg_to_rad(angle_degrees_top)
	var y_movement = screen_size.x * tan(angle_radians_top)
	
	end_point_top.x = start_point_top.x + screen_size.x
	# Prevent from moving too close to the screen edge
	end_point_top.y = max(MIN_DISTANCE_FROM_EDGE, start_point_top.y - y_movement)
	# Prevent from making river too narrow
	end_point_top.y = min(end_point_top.y, (screen_size.y / 2) - (MIN_RIVER_WIDTH / 2))
	
	return end_point_top
	
func generate_new_bottom_endpoint(previous_end_bottom: Vector2) -> Vector2:
	var start_point_bottom: Vector2 = previous_end_bottom
	var end_point_bottom: Vector2
	
	var angle_degrees_bottom = randf_range(-MAX_ANGLE, MAX_ANGLE)
	var angle_radians_bottom = deg_to_rad(angle_degrees_bottom)
	var y_movement = screen_size.x * tan(angle_radians_bottom)
	
	end_point_bottom.x = start_point_bottom.x + screen_size.x
	# Prevent from moving too close to the screen edge 
	end_point_bottom.y = max(MIN_DISTANCE_FROM_EDGE, start_point_bottom.y + y_movement)
	# Prevent from making river too narrow
	end_point_bottom.y = min(end_point_bottom.y, (screen_size.y / 2) + (MIN_RIVER_WIDTH / 2))
	
	return end_point_bottom
