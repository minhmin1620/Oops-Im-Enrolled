extends Node

@export var foodRemaining : Label
@export var timeLabel : Label
@export var FoodItems : Node2D
@export var Brian : CharacterBody2D
@export var music : AudioStreamPlayer2D
@export var lostScreen : AcceptDialog
var foodToCollect = 0
var timeleft
var allFoodCollected
var dialogueFinished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeleft = 80
	allFoodCollected = false
	dialogueFinished = false
	for child in FoodItems.get_children():
		child.hit.connect(collectFood)
		foodToCollect += 1
	foodRemaining.text = "Food Remaining: " + str(foodToCollect)
	var bubble_position = Brian.global_position + Vector2(-30,20)  
	DialogueManager.start_dialog(bubble_position, Brian.firstDialogue)
	print("Starting dialogue at: ", bubble_position)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	Brian.setCanMove(false)
	$Food31.visible = false
	$Food31.monitoring = false
	music.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not allFoodCollected and dialogueFinished and timeleft > 0):
		timeleft -= delta
		timeLabel.text = "Time Remaining: " + str(int(timeleft))
	if foodToCollect == 0 and $Food31.visible == false:
		allFoodCollected = true
		$Food31.visible = true
		$Food31.monitoring = true
		$Food31.hit.connect(winGame)
	if timeleft <= 0:
		loseGame()
	
func collectFood():
	foodToCollect -= 1
	foodRemaining.text = "Food Remaining: " + str(foodToCollect)
	
func winGame():
	Brian.setCanMove(false)
	var bubble_position = Brian.global_position + Vector2(-30,20)  
	DialogueManager.start_dialog(bubble_position, Brian.endDialogue)
	print("Starting dialogue at: ", bubble_position)
	DialogueManager.dialogue_finished.connect(_on_end_dialogue_finished)

func loseGame():
	lostScreen.visible = true
	Brian.setCanMove(false)

func _on_end_dialogue_finished():
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")
	
	
func _on_dialogue_finished():
	Brian.setCanMove(true)
	dialogueFinished = true


func _on_accept_dialog_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame2/minigame_2.tscn", GameState.player_position, GameState.currentQuest)


func _on_button_pressed() -> void:
	GameState.fail_minigame("res://Scene/MainWorld/main_world.tscn")
