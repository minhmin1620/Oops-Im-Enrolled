extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var canmove = true

const firstDialogue: Array[String] = [
	"Thank god for coffee!",
	"And food's ok too I guess...",
	"Let's get fueled up!",
]

const endDialogue: Array[String] = [
	"That's much better.",
	"Time to conquer the day!",
]

func _physics_process(delta: float) -> void:
	if not canmove:
		$anim.animation = "standing"
		$anim.play()
		return
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	else:
		velocity.y = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$anim.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = SPEED*-1
		$anim.flip_h = true
	
	if velocity == Vector2.ZERO:
		$anim.animation = "standing"
	else:
		$anim.animation = "walking"
	$anim.play()
	move_and_slide()

func setCanMove(canBrianMove: bool):
	canmove = canBrianMove
