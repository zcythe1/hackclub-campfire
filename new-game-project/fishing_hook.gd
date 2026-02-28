extends Area2D

var launch_angle = PI/6
var velocity = Vector2.ZERO
var thrown = false

func throw(power):
	thrown = true
	
	velocity.x = 0
	velocity.y = 0
	velocity.x = power * cos(launch_angle)
	velocity.y = -power * sin(launch_angle)
	print(velocity)

func _physics_process(delta: float) -> void:
	
	velocity.y += 9.81 * delta * 5
	
	if (!thrown):
		velocity = Vector2.ZERO
	
	position += velocity * delta
	velocity -= velocity * delta
