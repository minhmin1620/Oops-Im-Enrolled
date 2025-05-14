extends CharacterBody2D

@export var move_speed: float = 80.0
@export var min_wander_time: float = 1.0
@export var max_wander_time: float = 3.0
@export var anim : AnimatedSprite2D

var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var current_wander_time: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	set_new_wander_direction()
	update_animation()

func _physics_process(delta):
	# Update timer
	wander_timer += delta
	
	# Change direction when timer expires
	if wander_timer >= current_wander_time:
		set_new_wander_direction()
		update_animation()
	
	# Move the squirrel
	velocity = wander_direction * move_speed
	move_and_slide()

func set_new_wander_direction():
	# Get random direction (normalized)
	wander_direction = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()
	
	# Set random duration for this direction
	current_wander_time = randf_range(min_wander_time, max_wander_time)
	wander_timer = 0.0

func update_animation():
	if wander_direction.length() < 0.1:
		anim.animation = "idle"
		return
	
	# Determine primary movement direction
	if abs(wander_direction.x) > abs(wander_direction.y):
		# Moving mostly horizontally
		if wander_direction.x > 0:
			anim.animation = "run_right"
		else:
			anim.animation = "run_left"
	else:
		# Moving mostly vertically
		if wander_direction.y > 0:
			anim.animation = "run_down"
		else:
			anim.animation = "run_up"
	anim.play()
