extends Node2D

@export var spawn_radius: float = 500.0
@export var common_fish: Array[PackedScene] = []
@export var uncommon_fish: Array[PackedScene] = []
@export var rare_fish: Array[PackedScene] = []
@export var secret_fish: Array[PackedScene] = []

@onready var spawn_area = $boundary

func _ready():
	for child in get_children():
		print(child.name, " -> ", child)
		for grandchild in child.get_children():
			print("  ", grandchild.name, " -> ", grandchild)
	await get_tree().process_frame
	spawn_fish()

func get_random_spawn_point() -> Vector2:
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, spawn_radius)
	return Vector2(cos(angle), sin(angle)) * distance

func is_point_in_area(point: Vector2) -> bool:
	var shape_node = get_node("boundary")
	if shape_node == null:
		print("CollisionShape2D not found!")
		return true
	var shape = shape_node.shape
	var local_point = shape_node.to_local(to_global(point))
	return shape.collide(Transform2D.IDENTITY, RectangleShape2D.new(), Transform2D(0, local_point))

func pick_fish_for_distance(distance: float) -> PackedScene:
	var t = distance / spawn_radius
	var common_weight   = lerpf(0.80, 0.10, t)
	var uncommon_weight = lerpf(0.15, 0.30, t)
	var rare_weight     = lerpf(0.04, 0.10, t)
	var secret_weight   = lerpf(0.0001, 0.001, t)
	var total = common_weight + uncommon_weight + rare_weight + secret_weight
	var roll = randf() * total
	var pool: Array[PackedScene]
	if roll < common_weight:
		pool = common_fish
	elif roll < common_weight + uncommon_weight:
		pool = uncommon_fish
	elif roll < common_weight + uncommon_weight + rare_weight:
		pool = rare_fish
	else:
		pool = secret_fish
	if pool.is_empty():
		return null
	return pool[randi() % pool.size()]

func spawn_fish() -> void:
	for i in 100:
		var point = get_random_spawn_point()
		if not is_point_in_area(point):
			continue
		var distance = point.length()
		var scene = pick_fish_for_distance(distance)
		if scene == null:
			continue
		var fish = scene.instantiate()
		fish.position = point
		add_child(fish)
		# Connect the fish's caught signal so a new one spawns when it's caught
		if fish.has_signal("caught"):
			fish.caught.connect(_on_fish_caught)

func spawn_single_fish() -> void:
	for _attempt in 100:
		var point = get_random_spawn_point()
		if not is_point_in_area(point):
			continue
		var distance = point.length()
		var scene = pick_fish_for_distance(distance)
		if scene == null:
			return
		var fish = scene.instantiate()
		fish.position = point
		add_child(fish)
		if fish.has_signal("caught"):
			fish.caught.connect(_on_fish_caught)
		return

func _on_fish_caught() -> void:
	spawn_single_fish()
