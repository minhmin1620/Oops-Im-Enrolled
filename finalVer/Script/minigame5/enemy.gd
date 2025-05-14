
extends CharacterBody2D

enum State { PATROL, CHASE, RETURN }

@onready var path_follow = get_parent()  # Enemy1's parent is PathFollow2D
@onready var player = get_node("/root/minigame5/Player")  # Update the path to your player
@onready var enemy = $NavigationAgent2D
@onready var raycast = $RayCast2D  # Add this for Line of Sight detection
@onready var spawnpoint: Marker2D = $"../../../Spawnpoint"
@onready var heartbeat_audio: AudioStreamPlayer2D = $heartbeat_audio
@onready var background_music: AudioStreamPlayer2D = $"../../../Player/BackgroundMusic"



var state = State.PATROL
var chase_timer = 0.0

var patrol_speed = 0.05  # Speed along the path
var chase_speed = 75    # Speed while chasing
var previous_position = Vector2.ZERO


var detection_radius = 200  # Detection distance

func _physics_process(delta):
	match state:
		State.PATROL:
			patrol(delta)
		State.CHASE:
			chase(delta)
		State.RETURN:
			return_to_path(delta)

	# Update RayCast2D to face movement direction
	if velocity.length() > 0:
		raycast.rotation = velocity.angle()

func patrol(delta):
	if path_follow.is_patrolling == false:
		path_follow.start_patrol()

	# Move along the path
	path_follow.progress += patrol_speed * delta
	global_position = path_follow.global_position

	# Calculate velocity from change in position
	if previous_position != Vector2.ZERO:
		velocity = (global_position - previous_position) / delta

	previous_position = global_position  # Save for next frame

	update_animation_from_velocity()

	if is_player_visible():
		state = State.CHASE
		chase_timer = 10.0
		enemy.set_target_position(player.global_position)
		path_follow.stop_patrol()


func chase(delta):
	var playerPosi = player.global_position
	enemy.target_position = playerPosi

	var curr_agent_position = global_position
	var next_path_position = enemy.get_next_path_position()
	var new_velocity = curr_agent_position.direction_to(next_path_position) * chase_speed

	if enemy.avoidance_enabled:
		enemy.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	if background_music.playing:
		background_music.volume_db = -25  # quiet background

	if not heartbeat_audio.playing:
		heartbeat_audio.play()

	move_and_slide()

	chase_timer -= delta
	update_animation_from_velocity()

	if chase_timer <= 0:
		var path_pos = path_follow.global_position
		enemy.set_target_position(path_pos)  # <<< Set target to path 
		
		state = State.RETURN

func return_to_path(delta):
	if background_music.playing:
			background_music.volume_db = 0  # restore full volume

	if heartbeat_audio.playing:
		heartbeat_audio.stop()
	
	if not enemy.is_navigation_finished():
		var next_path_position = enemy.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		velocity = direction * chase_speed
		update_animation_from_velocity()

		move_and_slide()

	# If close to target (path), snap and switch back to PATROL
	if global_position.distance_to(enemy.target_position) < 10:
		global_position = path_follow.global_position
		state = State.PATROL
		path_follow.start_patrol()

	# Check if player is visible during return
	if is_player_visible():
		state = State.CHASE
		chase_timer = 10.0
		enemy.set_target_position(player.global_position)
		path_follow.stop_patrol()

func is_player_visible() -> bool:
	# Check distance first
	if global_position.distance_to(player.global_position) > detection_radius:
		return false

	# RayCast facing forward (already rotated based on velocity)
	raycast.target_position = Vector2.RIGHT * detection_radius  # Always right relative to RayCast's rotation
	raycast.force_raycast_update()

	# Check if wall or player is hit
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player:
			return true  # Player visible
		else:
			return false  # Wall blocking
	else:
		return false

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	
func update_animation_from_velocity():
	if velocity.length() == 0:
		return

	var sprite = $AnimatedSprite2D

	if abs(velocity.x) > abs(velocity.y):
		sprite.animation = "side"
		sprite.flip_h = velocity.x < 0  # Flip if moving left
	else:
		sprite.flip_h = false  # Make sure it's not flipped vertically
		if velocity.y > 0:
			sprite.animation = "down"
		else:
			sprite.animation = "up"

	sprite.play()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.global_position = spawnpoint.global_position
		state = State.RETURN
		
