extends CharacterBody2D
class_name Player


@export var projectile_scene: PackedScene

@onready var direction: Vector2 = Vector2.ZERO
@onready var screen_size = get_viewport_rect().size

const SPEED: int = 300
const SHOT_COOLDOWN: float = 0.3
const MAX_FUEL: int = 100
const FUEL_CONSUMPTION: int = 5

var input_map = {
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN
}
var time_since_last_shot: float = 0.0
var current_fuel: int
var dead: bool = false

signal fuel_changed
signal player_died


func _ready():
	$FuelTimer.timeout.connect(on_fuel_timer_timeout)
	$FuelTimer.start()
	add_to_group("player")

func _process(delta):
	if dead:
		velocity = Vector2.ZERO
		return
	# Moving
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size - Vector2(20, 20))
	
	# Shooting
	time_since_last_shot += delta
	if Input.is_action_just_pressed("shoot") and time_since_last_shot >= SHOT_COOLDOWN:
		shoot()
		time_since_last_shot = 0.0
		
	if current_fuel <= 0:
		player_died.emit()
	
func shoot():
	$ShootComponent.shoot()
		
func on_fuel_timer_timeout():
	current_fuel -= FUEL_CONSUMPTION
	fuel_changed.emit(current_fuel)
	
func refuel(amount: int):
	current_fuel += amount
	current_fuel = clamp(current_fuel, 0, MAX_FUEL)
	fuel_changed.emit(current_fuel)
	
func reset_position(pos: Vector2):
	position = pos
	$AnimatedSprite2D.play("default")
	current_fuel = MAX_FUEL
	$FuelTimer.start()
	
func play_death_animation():
	dead = true
	$AnimatedSprite2D.scale = Vector2(2.0, 2.0)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	player_died.emit()
