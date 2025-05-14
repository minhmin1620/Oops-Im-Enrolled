extends Node2D

@onready var player: Node2D = $Brian
@onready var canvas: CanvasLayer = $Canvas

var dialougeIsDone = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if  not dialougeIsDone:
			var bubble_position = player.global_position + Vector2(-10,25)
			DialogueManager.start_dialog(bubble_position, player.endOfYearDialogue)
			dialougeIsDone = true
			DialogueManager.dialogue_finished.connect(_on_dialogue_finished)


func _on_dialogue_finished():
	var sprite = $Brian/AnimatedSprite2D
	if sprite.is_playing():
		sprite.animation = "idle"
		sprite.stop()
	canvas.show()


func _on_back_to_main_world_pressed() -> void:
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")


func _on_exit_game_pressed() -> void:
	get_tree().quit()
