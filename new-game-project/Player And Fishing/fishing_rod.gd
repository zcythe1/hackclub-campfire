extends Node2D

var power = 10
var power_max = 500

var gravity = 9.81 * 5

@onready var fishing_hook = $"Fishing Hook"

var launch_angle = PI/6
var velocity = Vector2.ZERO

var state = "reeled"

var reel_direction = Vector2.ZERO
var reel_speed = 100

@onready var reeled_pos = $"Fishing Hook".position
var start_pos = reeled_pos


func _input(event: InputEvent):
	if state == "reeled":
		while event.is_action_pressed("Fish"):
			if power < power_max:
				power += 20
			await get_tree().create_timer(0.1).timeout
		if event.is_action_released("Fish"):
			throw(power)
			power = 10
	
	if state == "thrown":
		if event.is_action_pressed("Fish"):
			reel()
			await get_tree().create_timer(1).timeout
	
	if state == "reeling":
		if event.is_action_released("Fish") && velocity != Vector2.ZERO:
			state = "thrown"
	

func throw(throw_power):
	start_pos = fishing_hook.position
	state = "thrown"
	
	velocity = Vector2.ZERO
	velocity.x = throw_power * cos(launch_angle)
	velocity.y = -throw_power * sin(launch_angle)

func reel():
	if state != "reeling":
		velocity = Vector2.ZERO
	state = "reeling"
	


func _physics_process(delta: float) -> void:
	if state == "thrown":
		velocity.y += gravity * delta
	
	if state == "reeling":
		reel_direction = fishing_hook.position - reeled_pos
		reel_direction = reel_direction.normalized()
		velocity -= reel_direction * reel_speed * delta
		
		if ((start_pos - fishing_hook.position).length() < 10):
			fishing_hook.position = start_pos
			velocity = Vector2.ZERO
			if !Input.is_action_pressed("Fish"):
				state = "reeled"
		
	fishing_hook.position += velocity * delta
	velocity -= velocity * delta * 1.2
