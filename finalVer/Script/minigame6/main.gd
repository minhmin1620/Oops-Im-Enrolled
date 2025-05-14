extends Node2D

@onready var food_counter_label = $FoodTrackerContainer/FoodCounterLabel
@onready var win_dialog = $WinDialog 
@export var target_food_count: int = 35
var food_collected := 0
var game_won := false
@onready var food_container = $FoodItems
@onready var alco_container = $AlcoItems
@onready var spawn_timer = $SpawnTimer
@onready var player = $Player
@onready var timer_label = $TimerLabel
@export var music : AudioStreamPlayer2D
var seconds_passed := 0

var food_scenes := [
	preload("res://Scene/minigame6/food1.tscn"),
	preload("res://Scene/minigame6/food_2.tscn"),
	preload("res://Scene/minigame6/food_3.tscn"),
	preload("res://Scene/minigame6/food_4.tscn")
]

var alcohol_scenes := [
	preload("res://Scene/minigame6/alco_1.tscn"),
	preload("res://Scene/minigame6/alco_2.tscn"),
	preload("res://Scene/minigame6/alco_3.tscn")
]

@onready var hearts = [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3
]

@export var alcohol_chance: float = 0.3
@export var min_spawn_interval = 0.3
@export var max_spawn_interval = 2
var health := 3
var time_passed = 0.0

func _ready():
	randomize()
	_update_spawn_timer()
	var game_timer = Timer.new()
	game_timer.wait_time = 1.0
	game_timer.one_shot = false
	game_timer.timeout.connect(_on_game_timer_tick)
	add_child(game_timer)
	game_timer.start()
	music.play()


func _update_spawn_timer():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var dynamic_max = clamp(max_spawn_interval - time_passed * 0.01, min_spawn_interval, max_spawn_interval)
	spawn_timer.wait_time = rng.randf_range(min_spawn_interval, dynamic_max)
	spawn_timer.start()


func _on_spawn_timer_timeout():
	spawn_item()
	time_passed += spawn_timer.wait_time
	alcohol_chance = clamp(alcohol_chance + 0.01, 0.3, 0.9)
	_update_spawn_timer()

func spawn_item():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var base_count = 1
	var extra_items = int(time_passed / 10)  # Add 1 item every 10 seconds
	var total_to_spawn = min(base_count + extra_items, 5)
	
	for i in total_to_spawn:
		var is_alcohol = rng.randf() < alcohol_chance
		var x_pos = rng.randi_range(280, 1020)
		var spawn_pos = Vector2(x_pos, -120)

		var item_scene: PackedScene
		
		if is_alcohol:
			item_scene = alcohol_scenes.pick_random()
		else:
			item_scene = food_scenes.pick_random()
		
		var item = item_scene.instantiate()
		if is_alcohol:
			alco_container.add_child(item)
			item.add_to_group("alcohol")
		else:
			food_container.add_child(item)
			item.add_to_group("food")

		item.position = spawn_pos
		item.set_fall_speed(rng.randi_range(150, 250))
		item.connect("caught", self._on_item_caught)

func _on_item_caught(is_alcohol: bool):
	if game_won:
		return

	if is_alcohol:
		health -= 1
		player.play_hit_animation()
	else:
		if health < 3:
			health += 1
		food_collected += 1
		update_food_counter()

		if food_collected >= target_food_count:
			win_game()

	update_hearts()

	if health <= 0:
		game_over()

func update_food_counter():
	food_counter_label.text = "Food: %d/%d" % [food_collected, target_food_count]

func win_game():
	game_won = true
	timer_label.hide()
	spawn_timer.stop()
	win_dialog.popup_centered()


func _on_game_timer_tick():
	seconds_passed += 1
	timer_label.text = "Time: %s" % seconds_passed
	if game_won:
		timer_label.text = "Your time is: %s" % seconds_passed
		timer_label.hide()

func update_hearts():
	for i in range(hearts.size()):
		hearts[i].visible = i < health

func game_over():
	spawn_timer.stop()
	timer_label.hide()
	$GameOverDialog.popup_centered()


func _on_confirmation_dialog_confirmed() -> void:
	GameState.fail_minigame("res://Scene/MainWorld/main_world.tscn")


func _on_confirmation_dialog_canceled() -> void:
	get_tree().reload_current_scene()


func _on_win_dialog_canceled() -> void:
	get_tree().reload_current_scene()
	
func _on_win_dialog_confirmed():
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")
