extends Node2D


const DEFAULT_RIVER_WIDTH: float = 300.0
const MIN_RIVER_WIDTH: float = 200
const MIN_DISTANCE_FROM_EDGE: float = 50.0
const MAX_ANGLE: float = 15.0

var screen_size
var segment_length: float
var previous_end_top: Vector2
var previous_end_bottom: Vector2


func _ready() -> void:
	screen_size = get_viewport().size
	segment_length = screen_size.x
	
	create_first_segment()

func create_first_segment():
	# First segment will be straight
	var start_point_top = Vector2(0, (screen_size.y / 2) - (DEFAULT_RIVER_WIDTH / 2))
	var start_point_bottom = Vector2(0, (screen_size.y / 2) + (DEFAULT_RIVER_WIDTH / 2))
	
	var end_point_top = Vector2(screen_size.x, start_point_top.y)
	var end_point_bottom = Vector2(screen_size.x, start_point_bottom.y)
	
	create_top_bank(start_point_top, end_point_top)
	create_bottom_bank(start_point_bottom, end_point_bottom)
	create_river(start_point_top, end_point_top, start_point_bottom, end_point_bottom)
	
	previous_end_top = end_point_top
	previous_end_bottom = end_point_bottom
	
func create_top_bank(start_point: Vector2, end_point: Vector2):
	var top_bank = Polygon2D.new()
	
	# Create polygon points: river edge + screen edges
	var points = PackedVector2Array()
	points.append(start_point)           # Start of river edge
	points.append(end_point)             # End of river edge  
	points.append(Vector2(screen_size.x, 0)) # Top right corner of screen
	points.append(Vector2(0, 0))             # Top left corner of screen
	
	top_bank.polygon = points
	top_bank.color = Color.GREEN
	add_child(top_bank)
	
	return 
	
func create_bottom_bank(start_point: Vector2, end_point: Vector2):
	var bottom_bank = Polygon2D.new()
	
	# Create polygon points: river edge + screen edges
	var points = PackedVector2Array()
	points.append(start_point)                    # Start of river edge
	points.append(end_point)                      # End of river edge
	points.append(Vector2(screen_size.x, screen_size.y)) # Bottom right corner 
	points.append(Vector2(0, screen_size.y))             # Bottom left corner
	 
	bottom_bank.polygon = points
	bottom_bank.color = Color.GREEN
	add_child(bottom_bank)
	
	print("bottom points: ", points)
	
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
	
	print("river points: ", points)

func _process(delta: float) -> void:
	pass

func generate_new_top_endpoint() -> Vector2:
	var start_point_top: Vector2 = previous_end_top
	var end_point_top: Vector2
	
	var angle_degrees_top = randf_range(-MAX_ANGLE, MAX_ANGLE)
	var angle_radians_top = deg_to_rad(angle_degrees_top)
	
	end_point_top.x = position.x + screen_size.x
	# Prevent from moving too close to the screen edge
	end_point_top.y = max(MIN_DISTANCE_FROM_EDGE, screen_size.x * tan(angle_radians_top))
	# Prevent from making river too narrow
	end_point_top.y = min(end_point_top.y, (screen_size.y / 2) - (MIN_RIVER_WIDTH / 2))
	
	return end_point_top
	
func generate_new_bottom_endpoint() -> Vector2:
	var start_point_bottom: Vector2 = previous_end_bottom
	var end_point_bottom: Vector2
	
	var angle_degrees_bottom = randf_range(-MAX_ANGLE, MAX_ANGLE)
	var angle_radians_bottom = deg_to_rad(angle_degrees_bottom)
	
	end_point_bottom.x = position.x + screen_size.x
	# Prevent from moving too close to the screen edge
	end_point_bottom.y = max(MIN_DISTANCE_FROM_EDGE, screen_size.x * tan(angle_radians_bottom))
	# Prevent from making river too narrow
	end_point_bottom.y = min(end_point_bottom.y, (screen_size.y / 2) + (MIN_RIVER_WIDTH / 2))
	
	return end_point_bottom
