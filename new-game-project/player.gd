extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
		animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")

	# Override animation when in air
	if not is_on_floor():
		animated_sprite.play("jump")  # optional, if you have a jump anim

	move_and_slide()
