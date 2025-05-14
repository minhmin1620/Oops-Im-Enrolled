extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -450.0
var movable = true

const lines: Array[String] = [
	"Of course I lose my dorm key...",
	"On a field trip for an elective that I pay $$$ to take",
	"That has no applications in the field of CS...",
	"I better hurry and find it -",
	"My ramen is getting cold!",
]

const noKey: Array[String] = [
	"Ok, well here is the bus...",
	"But I still have not found my dorm key.",
	"I'll have to go back and find it before I leave.",
]

func ready():
	movable = true
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not movable:
		$anim.animation = "standing"
		$anim.play()
		return
	
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

func pause():
	movable = false

func play():
	movable = true
