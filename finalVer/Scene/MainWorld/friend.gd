extends CharacterBody2D

@export var speed: float = 100.0
@export var walk_distance: float = 100.0

var start_position: Vector2
var target_position: Vector2
var moving_right: bool = true

var standing
const lines: Array[String] = [
	"Brian! Thank goodness you are here...",
	"I tried to park but the potholes started looking like sinkholes and I panicked.",
	"I bailed. The car’s still running.",
	"It’s somewhere near the science library.", 
	"You gotta park it for me before it gets swallowed.",
]

const thanks: Array[String] = [
	"Wow I can't believe you pulled that off!",
	"You're a lifesaver Brian.",
	"Good luck on your midterm today!",
]

func _ready():
	start_position = position
	target_position = start_position + Vector2(walk_distance, 0)
	standing = false

func _physics_process(delta):
	# Calculate movement direction
	var direction: Vector2
	if standing:
		velocity = speed * direction
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
		move_and_slide()
		return
	if moving_right:
		direction = (target_position - position).normalized()
		$AnimatedSprite2D.animation = "walk-right"
	else:
		direction = (start_position - position).normalized()
		$AnimatedSprite2D.animation = "walk_left"
	
	# Move the character
	velocity = direction * speed
	$AnimatedSprite2D.play()
	move_and_slide()
	
	# Check if reached target and need to turn around
	if moving_right and position.distance_to(start_position) >= walk_distance:
		moving_right = false
	elif not moving_right and position.distance_to(target_position) >= walk_distance:
		moving_right = true

func setStanding(isStanding: bool):
	standing = isStanding
