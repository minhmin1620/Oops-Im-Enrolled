extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame1/minigame_1.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame2/minigame_2.tscn")

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame3/minigame_3.tscn")

func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame5/minigame_5.tscn")

func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame4/forest_minigame.tscn")

func _on_main_world_pressed() -> void:
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")

func _on_button_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/minigame6/minigame_6.tscn")
