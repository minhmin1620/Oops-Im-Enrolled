# game_state.gd
extends Node

var player_position = Vector2(530,300)
var minigame_number = 0
signal game_complete
var pending_game_complete = false
var main_menu = true
var firstPlay = true
var startingGame = true
var currentQuest = "Current Quest: ???"
var gameFailed = false





func emit_game_complete():
	if not is_instance_valid(get_tree().current_scene) || !get_tree().current_scene.is_inside_tree():
		pending_game_complete = true
	else:
		emit_signal("game_complete")
		
func enter_minigame(path_to_minigame: String, brian_pos: Vector2, quest: String):
	player_position = brian_pos
	currentQuest = quest
	if (path_to_minigame == "res://Scene/MainMenu/main_menu.tscn" or path_to_minigame == "res://Scene/minigame1/minigame_1.tscn" or path_to_minigame == "res://Scene/PauseScreen/pause_screen.tscn"):
		main_menu = true
	else:
		main_menu = false
	if path_to_minigame == "res://Scene/PauseScreen/pause_screen.tscn":
		pause_dialog()
	print("Brian's position as being sent to game_state: ", brian_pos)
	get_tree().change_scene_to_file(path_to_minigame)

func exit_minigame(path_to_main_world: String):
	get_tree().change_scene_to_file(path_to_main_world)
	if (not main_menu and firstPlay):
		minigame_number += 1
		firstPlay = true
	else:
		firstPlay = true
	emitGameCompleted()

func emitGameCompleted():
	emit_signal("game_complete")
	
func fail_minigame(path_to_main_world: String):
	get_tree().change_scene_to_file(path_to_main_world)
	gameFailed = true
	emitGameCompleted()

func pause_dialog():
	DialogueManager.dialogue_input_enabled = false
	if is_instance_valid(DialogueManager.text_box):
		DialogueManager.text_box.visible = false

#func resume_dialog():
	#DialogueManager.dialogue_input_enabled = true
	#if is_instance_valid(DialogueManager.text_box):
		#DialogueManager.text_box.visible = true
