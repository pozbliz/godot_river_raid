extends Node

signal spawn_requested(enemy_type: String)

var schedule = {
	"fuel": { "interval": 3.0, "elapsed": 0.0 },
	"ship": { "interval": 4.0, "elapsed": 0.0 },
	"helicopter": { "interval": 6.0, "elapsed": 0.0 },
	"jet": { "interval": 8.0, "elapsed": 0.0 },
	"bridge": { "interval": 20.0, "elapsed": 0.0}
}

func _init():
	set_process(false)

func start():
	set_process(true)

func _process(delta):
	for type in schedule.keys():
		schedule[type].elapsed += delta
		if schedule[type].elapsed >= schedule[type].interval:
			schedule[type].elapsed = 0.0
			spawn_requested.emit(type)
