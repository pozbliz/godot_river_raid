extends CharacterBody2D


@export var projectile_scene: PackedScene
@onready var direction: Vector2 = Vector2.ZERO
@onready var screen_size = get_viewport_rect().size

const SPEED: float = 300.0
const SHOT_COOLDOWN: float = 0.3

var input_map = {
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN
}
var time_since_last_shot = 0.0


func _ready():
	pass

func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size - $ColorRect.size)  # replace with sprite size
	
	time_since_last_shot += delta
	if Input.is_action_just_pressed("shoot") and time_since_last_shot >= SHOT_COOLDOWN:
		shoot()
		time_since_last_shot = 0.0
	
func shoot():
	var shot = projectile_scene.instantiate()
	owner.add_child(shot)
	shot.position = position
	
func reposition(pos: Vector2):
	position = pos
