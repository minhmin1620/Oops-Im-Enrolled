extends CharacterBody2D

@export var acceleration: float = 20
@export var max_speed: float = 100
@export var speed_limit: float = 90
@export var turn_speed: float = 2  
@export var start_position: Vector2 = Vector2(50, 50) 
@onready var speed_label = get_tree().get_current_scene().get_node("Map/Control/SpeedLabel")
@onready var win_dialog = get_node("WinDialog")
@onready var lose_dialog = get_node("LoseDialog")


var current_speed: float = 0.0
var parking_spot: Area2D
var main_node: Node

func _ready():
	position = start_position
	var current_scene = get_tree().get_current_scene()
	main_node = current_scene
	if current_scene.has_node("Map/WinningArea"):
		parking_spot = current_scene.get_node("Map/WinningArea")
	

func _physics_process(delta):
	if main_node and main_node.has_method("is_game_started") and not main_node.is_game_started():
		return
	if Input.is_action_pressed("ui_up"):  
		current_speed = min(current_speed + acceleration * delta, max_speed)
	else:
		current_speed = max(current_speed - acceleration * delta, 0)  

	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction * current_speed

	if speed_label:
		speed_label.text = "Speed: " + str(round(current_speed/3)) + " km/h"

	if Input.is_action_pressed("ui_left"):
		rotation -= turn_speed * delta

	if Input.is_action_pressed("ui_right"):
		rotation += turn_speed * delta
	
	var motion = direction * current_speed * delta
	var collision = move_and_collide(motion)
	
	if collision:
		var collided_object = collision.get_collider() 
		if collided_object.is_in_group("obstacle"): 
			respawn()
			return
	
	move_and_slide()
	if parking_spot and parking_spot.overlaps_body(self):
			main_node.finish_game_won()

	if current_speed > speed_limit:
		main_node.finish_game_lost_speed()

func respawn():
	position = start_position
	rotation = 1.5
	current_speed = 0
	
