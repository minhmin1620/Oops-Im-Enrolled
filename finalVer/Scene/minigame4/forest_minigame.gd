extends Node2D

@export var key : Area2D
@export var keyLabel : Label
@export var bus : Area2D
@export var tryAgainLabel : Label
@export var instructionRect : ColorRect
@export var introRect : ColorRect
@export var outroRect : ColorRect
@export var beginDialogue : Area2D
@export var brian : CharacterBody2D
@export var backgroundMusic : AudioStreamPlayer2D

var dialogueComplete
var timer
var timer2
var winable 
var musicTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key.hit.connect(collectKey)
	bus.hit.connect(displayEnd)
	keyLabel.visible = false
	tryAgainLabel.visible = false
	timer = 5
	timer2 = 5
	winable = false
	dialogueComplete = false
	instructionRect.visible = false
	introRect.visible = true
	brian.pause()
	outroRect.visible = false
	musicTimer = 0
	#$AudioStreamPlayer2D.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	backgroundMusic.play()
	#get_viewport().gui_disable_input = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if brian.movable == false:
		return
	var cam_width = get_viewport_rect().size.x / $Cam.zoom.x
	var level_width = 10000  # Example level width in world units

	$Cam.position.x = clamp($Brian.position.x, cam_width / 2, level_width - cam_width / 2)
	if (keyLabel.visible):
		timer -= delta
		print(timer)
		if timer <= 0:
			keyLabel.visible = false
	if (tryAgainLabel.visible):
		timer2 -= delta
		print(timer)
		if timer2 <= 0:
			tryAgainLabel.visible = false

func collectKey():
	print("Key is collected")
	keyLabel.visible = true
	key.visible = false
	winable = true

func displayEnd():
	if winable:
		outroRect.visible = true
		brian.pause()
	else:
		var bubble_position = brian.global_position + Vector2(-30,20)  
		DialogueManager.start_dialog(bubble_position, brian.noKey)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
		brian.pause()
	
func endGame():
	if winable == true:
		GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")
	else:
		tryAgainLabel.visible = true
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	brian.position.x = 506
	brian.position.y = 418


func _on_button_pressed() -> void:
	brian.play()
	instructionRect.visible = false


func _on_button2_pressed() -> void:
	instructionRect.visible = true
	introRect.visible = false


func _on_button3_pressed() -> void:
	endGame()

#func _unhandled_input(event):
#	if event.is_action_pressed("ui_text_completion_accept"):
#		if beginDialogue.get_overlapping_bodies().size() > 0:
#			DialogueManager.start_dialog(global_position, brian.lines)
#			if beginDialogue.get_overlapping_bodies()[0].global_position.x < global_position.x: 
#				brian.flip_h = true

func _on_begin_dialogue_body_entered(body: Node2D) -> void:
	if body == brian and not dialogueComplete:  # Ensure only Brian triggers dialogue
		var bubble_position = brian.global_position + Vector2(-30,20)  # Adjust Y offset
		DialogueManager.start_dialog(bubble_position, brian.lines)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
		brian.pause()
		dialogueComplete = true

func _on_dialogue_finished():
	if DialogueManager.text_box:
		DialogueManager.text_box.queue_free()
	brian.play()
	
