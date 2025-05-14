extends CharacterBody2D

@export var speed: float = 200.0
@onready var animated_sprite = $AnimatedSprite2D
var is_hit = false

func _physics_process(delta: float) -> void:
	if is_hit:
		move_and_slide()
		return
	
	var input_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_direction * speed
	velocity.y = 0
	move_and_slide()

	if input_direction != 0:
		animated_sprite.play("walk")
		animated_sprite.flip_h = input_direction < 0
	else:
		animated_sprite.play("up")

func play_hit_animation():
	if is_hit:
		return 
	is_hit = true
	animated_sprite.play("hit")
	
	await get_tree().create_timer(0.5).timeout

	is_hit = false
	animated_sprite.play("up")
