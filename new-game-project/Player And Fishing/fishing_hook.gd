extends Area2D

@onready var hook = $CollisionShape2D


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Materials"):
		area.call_deferred("reparent", self)
		area.set_deferred("position", hook.position)
