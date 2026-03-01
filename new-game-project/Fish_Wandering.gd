extends Area2D
var wandering_circle_radius = 50
var travel_direction = Vector2.ZERO
var travel_time = 0
var travel_speed = 20
var on_hook = false
var starting_position
var hook_ref = null

func _ready() -> void:
	starting_position = self.position

func _physics_process(delta: float) -> void:
	if on_hook:
		if hook_ref:
			self.position = hook_ref.global_position
	else:
		if travel_time <= 0: 
			travel_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			travel_direction = travel_direction.normalized()
			travel_time = randf_range(2,4)
	
		if self.position.distance_to(starting_position) > wandering_circle_radius:
			travel_direction = -travel_direction
	
		travel_time -= delta
		self.position += travel_direction * travel_speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Fishing Rod"):
		print("SIGMA")
		on_hook = true
		hook_ref = area
