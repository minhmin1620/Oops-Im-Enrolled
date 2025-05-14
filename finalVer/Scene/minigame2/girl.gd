extends CharacterBody2D  # or CharacterBody3D for 3D games

@export var move_speed: float = 30.0
@export var min_wander_time: float = 3.0
@export var max_wander_time: float = 8.0
@export var min_idle_time: float = 2.0
@export var max_idle_time: float = 5.0
@export var change_direction_chance: float = 0.2  # 20% chance to change direction when hitting obstacles

var personID
var random_number2
var current_state: String = "idle"
var timer: float = 0.0
var current_duration: float = 0.0
var wander_direction: Vector2 = Vector2.ZERO

func _ready():
	set_random_idle_time()
	var random_number = randi() % 4 + 1
	if(random_number == 1):
		$AnimatedSprite2D.animation = "standing1"
	elif(random_number == 2):
		$AnimatedSprite2D.animation = "standing2"
	elif(random_number == 3):
		$AnimatedSprite2D.animation = "standing3"
	else:
		$AnimatedSprite2D.animation = "standing4"
	personID = random_number
	random_number2 = randi() % 4 + 1

func _physics_process(delta):
	if random_number2 == 1:
		return 
	match current_state:
		"wandering":
			timer += delta
			if timer >= current_duration:
				start_idle()
			else:
				move(delta)
		"idle":
			timer += delta
			if timer >= current_duration:
				start_wandering()

func start_wandering():
	current_state = "wandering"
	timer = 0.0
	current_duration = randf_range(min_wander_time, max_wander_time)
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#$AnimatedSprite2D.play("walk")  # Adjust for your animation setup
	if (personID == 1):
		$AnimatedSprite2D.play("walking1")
	elif (personID == 2):
		$AnimatedSprite2D.play("walking2")
	elif (personID == 3):
		$AnimatedSprite2D.play("walking3")
	elif (personID == 4):
		$AnimatedSprite2D.play("walking4")
	# Flip sprite based on direction
	if wander_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif wander_direction.x > 0:
		$AnimatedSprite2D.flip_h = false

func start_idle():
	current_state = "idle"
	timer = 0.0
	set_random_idle_time()
	if (personID == 1):
		$AnimatedSprite2D.play("standing1")
	elif (personID == 2):
		$AnimatedSprite2D.play("standing2")
	elif (personID == 3):
		$AnimatedSprite2D.play("standing3")
	elif (personID == 4):
		$AnimatedSprite2D.play("standing4")

func set_random_idle_time():
	current_duration = randf_range(min_idle_time, max_idle_time)

func move(delta):
	# Check for obstacles
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		position,
		position + wander_direction * 20.0,  # Look ahead a short distance
		collision_mask
	)
	var result = space_state.intersect_ray(query)
	
	if result:
		# Sometimes change direction when hitting something
		if randf() < change_direction_chance:
			wander_direction = wander_direction.rotated(randf_range(PI/4, PI/2)).normalized()
			# Flip sprite if needed
			if wander_direction.x < 0:
				$AnimatedSprite2D.flip_h = true
			elif wander_direction.x > 0:
				$AnimatedSprite2D.flip_h = false
		else:
			# Try to slide along the obstacle
			var normal = result["normal"]
			wander_direction = wander_direction.slide(normal).normalized()
	
	velocity = wander_direction * move_speed
	move_and_slide()

	# Occasionally make small direction adjustments
	if randf() < 0.05:  # 5% chance per frame
		wander_direction = wander_direction.rotated(randf_range(-0.2, 0.2)).normalized()
