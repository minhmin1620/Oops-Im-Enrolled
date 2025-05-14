extends CharacterBody2D

@onready var spawnpoint: Marker2D = $"../Spawnpoint"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const SPEED = 100
var canMove = false

const firstDialogue: Array[String] = [
	"You are lost in headhall (THE DUNGEON!!) -",
	"your classroom is at the exit of the maze.",
	"Go go you are about to be late for your midterm!!!!",
	"PS: Don't let the professor catch you -", 
	"or you will be reset to the start."
]

const wrongRoomDialogue: Array[String] = [ 
	"Oops, sorry wrong room!!!"
]


func _physics_process(delta: float) -> void:
	if  not canMove:
		velocity.x = 0
		velocity.y = 0
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
		return
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.animation = "walking"
		elif Input.is_action_pressed("ui_left"):
			velocity.x = SPEED*-1
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.animation = "walking"
		elif  Input.is_action_pressed("ui_up"):
			velocity.y = SPEED*-1
			$AnimatedSprite2D.animation = "walking"
		elif  Input.is_action_pressed("ui_down"):
			velocity.y = SPEED*1
			$AnimatedSprite2D.animation = "walking"
		else:
			velocity.x = 0
			velocity.y = 0
			$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
		move_and_slide()
	

func setCanMove(movable: bool):
	canMove = movable

################ WHEN YOU WIN ######################
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("area entered")
	get_tree().change_scene_to_file("res://Scene/EndScene/end_scene.tscn")
#####################################################
