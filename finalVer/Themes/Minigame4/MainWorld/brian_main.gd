extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -450.0

const lines: Array[String] = [
	"Hmm - Cellar Pub",
	"A bar sounds fun, but I have an exam tomorrow...",
	"I will go grab a spin dip for now!",
]

func _physics_process(delta: float) -> void:

	if not (Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		$anim.animation = "standing"
	
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
	else:
		velocity.x = 0
		
	$anim.animation = "walking"
	$anim.play()
	move_and_slide()
