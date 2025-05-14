extends Node2D

@onready var player: CharacterBody2D = %Player
var dialougeIsDone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.setCanMove(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if  not dialougeIsDone:
		var bubble_position = player.global_position + Vector2(-28,35)
		DialogueManager.start_dialog(bubble_position, player.firstDialogue)
		dialougeIsDone = true
		DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.setCanMove(true)

func _on_wrongRoom_body_entered(body: Node2D) -> void:
	player.setCanMove(false)
	var bubble_position = player.global_position + Vector2(-28,35)
	DialogueManager.start_dialog(bubble_position, player.wrongRoomDialogue)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
