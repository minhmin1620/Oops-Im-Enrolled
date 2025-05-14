extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -450.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and velocity.x == 0:
		$anim.animation = "standing"
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$anim.animation = "jump"
		
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$anim.flip_h = false
		$anim.animation = "walking"
	elif Input.is_action_pressed("ui_left"):
		velocity.x = SPEED*-1
		$anim.flip_h = true
		$anim.animation = "walking"
	else:
		velocity.x = 0
	$anim.play()
	move_and_slide()
