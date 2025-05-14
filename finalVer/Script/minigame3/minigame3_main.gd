extends Node

@onready var timer_label = get_node("Map/Control/TimerLabel")
@onready var game_timer = get_node("Map/Control/Timer")
@onready var game_rules_popup = get_node("GameRulesPopup")
@onready var play_button = get_node("GameRulesPopup/VBoxContainer/Button")
@onready var speed_label = get_tree().get_current_scene().get_node("Map/Control/SpeedLabel")
@onready var win_dialog = get_node("Map/Control/WinDialog")
@onready var lose_dialog = get_node("Map/Control/TimerLoseDialog")
@onready var speed_dialog = get_node("Map/Control/SpeedLoseDialog")

@export var music : AudioStreamPlayer2D
var game_started = false
var time_elapsed: int = 90

func _ready():
	game_timer.timeout.connect(_on_timer_timeout)
	game_rules_popup.visible = true
	game_timer.stop()
	play_button.pressed.connect(start_game)
	music.play()

func _on_timer_timeout():
	if time_elapsed > 0:
		time_elapsed -= 1
		timer_label.text = "Time: " + str(time_elapsed)
	else:
		finish_game_lost_time()

func start_game():
	game_rules_popup.visible = false
	game_timer.start()
	game_started = true

func finish_game_lost_time():
	lose_dialog.popup_centered()
	game_started = false
	game_timer.stop()
	
func finish_game_lost_speed():
	speed_dialog.popup_centered()
	game_started = false
	game_timer.stop()

func finish_game_won():
	print("You have parked successfully!")
	win_dialog.popup_centered()
	game_started = false
	game_timer.stop()

	
func is_game_started() -> bool:
	return game_started


func _on_restart_button_pressed() -> void:
	restart_game()

func restart_game():
	time_elapsed = 90
	timer_label.text = "Time: " + str(time_elapsed)
	game_started = true
	game_timer.start()
	
	lose_dialog.hide()
	game_rules_popup.visible = false

	var player = get_node("Map/Player")
	if player:
		player.respawn()


func _on_win_dialog_confirmed() -> void:
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")


func _on_speed_lose_dialog_confirmed() -> void:
	get_tree().reload_current_scene()


func _on_timer_lose_dialog_confirmed() -> void:
	get_tree().reload_current_scene()
