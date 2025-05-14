extends Node

@export var WordleConfirm : AcceptDialog
@export var ForestryConfirm : AcceptDialog
@export var CellarConfirm : AcceptDialog
@export var ParkingConfirm : AcceptDialog
@export var MealHallConfirm : AcceptDialog
@export var MazeConfirm : AcceptDialog
@export var ReplayGame : AcceptDialog
@export var NotAvailable : AcceptDialog

@export var CurrentQuest : Label
@export var music : AudioStreamPlayer2D

@export var Brian : CharacterBody2D
@export var Friend : CharacterBody2D

var minigames_completed
var GameComplete = false
var mealHallGameNum = 1
var forestGameNum = 2
var wordleGameNum = -1
var cellarGameNum = 3
var parkingGameNum = 4
var mazeGameNum = 5

var forestReplay = false
var cellarReplay = false
var parkingReplay = false
var mazeReplay = false
var mealHallReplay = false

var areaEntered = false
var displayed = false
var talkedToFriend = false
var examDialogue = true
var deltaCounter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deltaCounter = 0
	minigames_completed = 0
	print("Attempting to connect signal")
	var connect_result = GameState.game_complete.connect(on_game_exited)
	print("Connection result: ", connect_result)
	GameState.game_complete.connect(on_game_exited)
	Friend.visible = false
	music.play()
	Brian.setCanMove(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not GameComplete):
		GameState.emit_signal("game_complete")
		GameComplete = true
	if (GameState.startingGame == true):
		GameState.startingGame = false
		Brian.setCanMove(false)
		var bubble_position = Brian.global_position + Vector2(-30,20)
		DialogueManager.start_dialog(bubble_position, Brian.firstDialogue)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_first_dialogue_finished)
	if Input.is_action_just_pressed("ui_cancel"):
		GameState.enter_minigame("res://Scene/PauseScreen/pause_screen.tscn", Brian.position, CurrentQuest.text)
	#dialogue
	if(minigames_completed == forestGameNum-1) && not displayed:
		displayed = true
		Brian.setCanMove(false)
		var bubble_position = Brian.global_position + Vector2(-30,20)  
		DialogueManager.start_dialog(bubble_position, Brian.forestryGuideDialogue)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_forestry_dialogue_finished)
	elif(minigames_completed == cellarGameNum-1) && not displayed:
		displayed = true
		Brian.setCanMove(false)
		var bubble_position = Brian.global_position + Vector2(-30,20)  
		DialogueManager.start_dialog(bubble_position, Brian.exploreDialogue)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_explore_dialogue_finished)
	elif(minigames_completed == parkingGameNum-1 && not displayed):
		Friend.visible = true
		if (areaEntered == true and talkedToFriend == false):
			displayed = true
			Brian.setCanMove(false)
			var bubble_position = Brian.global_position + Vector2(-30,20)  
			DialogueManager.start_dialog(bubble_position, Brian.goToFriendDialogue)
			print("Starting dialogue at: ", bubble_position)
			DialogueManager.dialogue_finished.connect(_on_go_friend_dialogue_finished)
	elif(minigames_completed == mazeGameNum-1 and not displayed):
		Friend.visible = true
		if (areaEntered == true and talkedToFriend == false):
			displayed = true
			talkedToFriend = true
			Brian.setCanMove(false)
			var bubble_position = Friend.global_position + Vector2(-30,20)  
			DialogueManager.start_dialog(bubble_position, Friend.thanks)
			Friend.setStanding(true)
			print("Starting dialogue at: ", bubble_position)
			DialogueManager.dialogue_finished.connect(_on_friend_thanks_dialogue_finished)
	elif(minigames_completed == mazeGameNum):
		CurrentQuest.text = "Good job! Explore the main world and see if you can find any secrets!"
	deltaCounter += delta
	
func _on_friend_thanks_dialogue_finished():
	Brian.setCanMove(true)
	Friend.setStanding(false)
	
func _on_go_friend_dialogue_finished():
	CurrentQuest.text = "Current Quest: Help Adam"
	Brian.setCanMove(true)
	
func _on_first_dialogue_finished():
	CurrentQuest.text = "Current Quest: Get a coffee at meal hall"
	Brian.setCanMove(true)

func _on_explore_dialogue_finished():
	CurrentQuest.text = "Current Quest: Find somewhere to eat"
	Brian.setCanMove(true)

func _on_forestry_dialogue_finished():
	CurrentQuest.text = "Current Quest: Head to the forestry building"
	Brian.setCanMove(true)

func _on_wordle_body_entered(body: Node2D) -> void:
	if body.is_in_group("Brian"):
		WordleConfirm.visible = true


func _on_wordle_confirm_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame1/minigame_1.tscn", Brian.position, CurrentQuest.text)


func _on_forestry_body_entered(body: Node2D) -> void:
	if deltaCounter < 2:
		return
	if body == Brian and minigames_completed == (forestGameNum - 1):
		print("Forestry game - minigames completed (should be 0): ", minigames_completed)
		ForestryConfirm.visible = true
	elif body == Brian and minigames_completed < forestGameNum - 1:
		NotAvailable.visible = true
	elif body == Brian:
		ReplayGame.visible = true
		forestReplay = true


func _on_forestry_confirm_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame4/forest_minigame.tscn", Brian.position, CurrentQuest.text)

func on_game_exited():
	Brian.position = GameState.player_position
	minigames_completed = GameState.minigame_number
	if (GameState.gameFailed == true):
		CurrentQuest.text = GameState.currentQuest
		GameState.gameFailed = false
	print("on_game_exited function has been called.\nCurrent minigames complete: ", minigames_completed)
	
func _on_minigame_3_body_entered(body: Node2D) -> void:
	if deltaCounter < 2:
		return
	if (body == Brian and minigames_completed == parkingGameNum - 1 and talkedToFriend):
		print("Parking Game - minigames completed (should be 2): ", minigames_completed)
		ParkingConfirm.visible = true
	elif body == Brian:
		NotAvailable.visible = true


func _on_minigame_4_body_entered(body: Node2D) -> void:
	if deltaCounter < 2:
		return
	if (body == Brian and minigames_completed == mazeGameNum - 1):
		MazeConfirm.visible = true
	elif (body == Brian and minigames_completed < mazeGameNum - 1):
		NotAvailable.visible = true
	elif (body == Brian):
		ReplayGame.visible = true
		mazeReplay = true

func _on_minigame_5_body_entered(body: Node2D) -> void:
	if deltaCounter < 2:
		return
	if (body == Brian and minigames_completed == cellarGameNum - 1):  
		print("Cellar game - minigames completed (should be 1): ", minigames_completed)
		Brian.setCanMove(false)
		var bubble_position = Brian.global_position + Vector2(-30,20)  
		DialogueManager.start_dialog(bubble_position, Brian.cellarDialogue)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_cellar_dialogue_finished)
	elif body == Brian and minigames_completed < cellarGameNum - 1:
		NotAvailable.visible = true
	elif body == Brian:
		ReplayGame.visible = true
		cellarReplay = true

func _on_cellar_dialogue_finished():
	if DialogueManager.text_box:
		#await get_tree().create_timer(0.75).timeout
		DialogueManager.text_box.queue_free()
		CellarConfirm.visible = true
		Brian.setCanMove(true)
		
func _on_cellar_confirm_confirmed() -> void:
	print("This will start the cellar game.")
	GameState.enter_minigame("res://Scene/minigame6/minigame_6.tscn", Brian.position, CurrentQuest.text)


func _on_parking_confirm_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame3/minigame_3.tscn", Brian.position, CurrentQuest.text)


func _on_replay_game_confirmed() -> void:
	GameState.firstPlay = false
	if cellarReplay:
		cellarReplay = false
		GameState.enter_minigame("res://Scene/minigame6/minigame_6.tscn", Brian.position, CurrentQuest.text)
	if forestReplay:
		forestReplay = false
		GameState.enter_minigame("res://Scene/minigame4/forest_minigame.tscn", Brian.position, CurrentQuest.text)
	if mazeReplay:
		mazeReplay = false
		GameState.enter_minigame("res://Scene/minigame5/minigame_5.tscn", Brian.position, CurrentQuest.text)
	if parkingReplay:
		parkingReplay = false
		GameState.enter_minigame("res://Scene/minigame3/minigame_3.tscn", Brian.position, CurrentQuest.text)
	if mealHallReplay:
		mealHallReplay = false
		GameState.enter_minigame("res://Scene/minigame2/minigame_2.tscn", Brian.position, CurrentQuest.text)
		


func _on_minigame_6_body_entered(body: Node2D) -> void:
	if deltaCounter < 2:
		return
	if (body == Brian and minigames_completed == mealHallGameNum - 1):  
		MealHallConfirm.visible = true
	elif body == Brian and minigames_completed < mealHallGameNum - 1:
		NotAvailable.visible = true
	elif body == Brian:
		ReplayGame.visible = true
		mealHallReplay = true
	


func _on_meal_hall_confirm_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame2/minigame_2.tscn", Brian.position, CurrentQuest.text)


func _on_adam_area_body_entered(body: Node2D) -> void:
	if(body != Brian):
		return
	if (Friend.visible == false or talkedToFriend == true or minigames_completed == mazeGameNum - 1):
		return
	Friend.setStanding(true)
	talkedToFriend = true
	Brian.setCanMove(false)
	var bubble_position = Friend.global_position + Vector2(-30,20)  
	DialogueManager.start_dialog(bubble_position, Friend.lines)
	print("Starting dialogue at: ", bubble_position)
	DialogueManager.dialogue_finished.connect(_on_friend_dialogue_finished)

func _on_friend_dialogue_finished():
	Friend.setStanding(false)
	CurrentQuest.text = "Current Quest: Park Adam's car at the science library"
	Brian.setCanMove(true)


func _on_adam_area_2_body_entered(body: Node2D) -> void:
	if (minigames_completed == parkingGameNum-1 or minigames_completed == mazeGameNum-1) && not displayed && body == Brian :
		areaEntered = true


func _on_exam_area_body_exited(body: Node2D) -> void:
	if (minigames_completed < mazeGameNum - 1 or body != Brian):
		return
	if (examDialogue and talkedToFriend):
		examDialogue = false
		print("area being exited by Brian")
		Brian.setCanMove(false)
		var bubble_position = Brian.global_position + Vector2(-30,20)  
		DialogueManager.start_dialog(bubble_position, Brian.examDialogue)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_exam_dialogue_finished)

func _on_exam_dialogue_finished():
	Brian.setCanMove(true)
	CurrentQuest.text = "Current Quest: RUN TO HEAD HALL FOR YOUR MIDTERM"

func _on_maze_confirm_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame5/minigame_5.tscn", Brian.position, CurrentQuest.text)
