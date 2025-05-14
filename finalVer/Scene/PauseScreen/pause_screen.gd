extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")
	DialogueManager.dialogue_input_enabled = true
	if is_instance_valid(DialogueManager.text_box):
		DialogueManager.text_box.visible = true


func _on_exit_pressed() -> void:
	$AcceptDialog.visible = true

func _on_accept_dialog_confirmed() -> void:
	get_tree().quit()


func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/HelpScreen/help.tscn")
