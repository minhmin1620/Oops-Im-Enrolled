extends Node

@export var WordleConfirm : AcceptDialog
@export var ForestryConfirm : AcceptDialog
@export var CellarConfirm : AcceptDialog
@export var Brian : CharacterBody2D
var minigames_completed
var game1 = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minigames_completed = 0
	print("Attempting to connect signal")
	var connect_result = GameState.game_complete.connect(on_game_exited)
	print("Connection result: ", connect_result)
	GameState.game_complete.connect(on_game_exited)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.minigame_number == 1 and not game1:
		GameState.emit_signal("game_complete")
		game1 = true


func _on_wordle_body_entered(body: Node2D) -> void:
	if body.is_in_group("Brian"):
		WordleConfirm.visible = true


func _on_wordle_confirm_confirmed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame1/minigame_1.tscn")


func _on_forestry_body_entered(body: Node2D) -> void:
	if body.is_in_group("Brian") and not game1:
		ForestryConfirm.visible = true


func _on_forestry_confirm_confirmed() -> void:
	GameState.enter_minigame("res://Scene/minigame4/forest_minigame.tscn", Brian.position)

func on_game_exited():
	Brian.position = GameState.player_position
	minigames_completed = GameState.minigame_number
	print("on_game_exited function has been called.\nCurrent minigames complete: ", minigames_completed)
	


func _on_minigame_3_body_entered(body: Node2D) -> void:
	print("This is where the parking minigame will be")


func _on_minigame_4_body_entered(body: Node2D) -> void:
	print("This is where the head hall maze minigame will be")

func _on_minigame_5_body_entered(body: Node2D) -> void:
	if body == Brian:  # Ensure only Brian triggers dialogue
		var bubble_position = Brian.global_position + Vector2(75, -20)  # Adjust Y offset
		DialogueManager.start_dialog(bubble_position, Brian.lines)
		print("Starting dialogue at: ", bubble_position)
		DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	if DialogueManager.text_box:
		await get_tree().create_timer(0.75).timeout
		DialogueManager.text_box.queue_free()
		CellarConfirm.visible = true
		


func _on_cellar_confirm_confirmed() -> void:
	print("This will start the cellar game.")
