extends Node2D

var power = 10

@onready var fishing_hook = $"Fishing Hook"

func _input(event: InputEvent):
	while event.is_action_pressed("Fish"):
		power += 15
		await get_tree().create_timer(1).timeout
	
	if event.is_action_released("Fish"):
		launch_hook(power)
		power = 0

func launch_hook(rod_power):
	fishing_hook.throw(rod_power)
