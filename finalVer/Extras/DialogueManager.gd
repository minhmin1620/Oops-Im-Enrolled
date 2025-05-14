extends Node

@onready var text_box_scene = preload("res://Extras/speech_bubbles.tscn")

signal dialogue_finished

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

var dialogue_input_enabled: bool = true


func start_dialog(position: Vector2, lines: Array[String]):
	print("Start dialog called with position: ", position, " and lines: ", lines)
	if is_dialog_active:
		print("Dialog already active, ignoring...")
		return
	
	dialog_lines = lines
	text_box_position = position
	print("Displaying first line: ", dialog_lines[0])
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	#print("instantiating speech bubble at: ", text_box_position)
	#text_box = text_box_scene.instantiate()
	#text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	#get_tree().root.add_child(text_box)
	#text_box.global_position = text_box_position
	#text_box.display_text(dialog_lines[current_line_index])
	#can_advance_line = false
	print("instantiating speech bubble at: ", text_box_position)
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)

	var scene_name = get_tree().current_scene.name

	if scene_name == "minigame5":  # only use DialogueLayer here
		var dialogue_layer = get_tree().current_scene.get_node_or_null("DialogueLayer")
		if dialogue_layer:
			dialogue_layer.add_child(text_box)
		else:
			print("Warning: DialogueLayer not found in minigame5. Falling back.")
			get_tree().root.add_child(text_box)
	else:
		get_tree().root.add_child(text_box)  # fallback for other scenes

	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false

	
func _on_text_box_finished_displaying():
	can_advance_line = true
	if current_line_index >= dialog_lines.size() - 1 and Input.is_action_pressed("ui_text_completion_accep"):
		is_dialog_active = false
		dialogue_finished.emit()  # Notify when all dialogue is done
		print("dialogue finished signal emitted.")
		current_line_index = 0
	
func _unhandled_input(event):
	if not dialogue_input_enabled:
		return 
	
	if event.is_action_pressed("ui_text_completion_accept") and is_dialog_active and can_advance_line:
		if current_line_index >= dialog_lines.size() - 1:
			if event.is_action_pressed("ui_text_completion_accept"):
				is_dialog_active = false
				dialogue_finished.emit()  # Notify that dialogue is over
				text_box.queue_free()  # Remove the last speech bubble AFTER Enter is pressed
				current_line_index = 0  # Reset for next time

		else:
			text_box.queue_free()  # Remove current bubble
			current_line_index += 1
			_show_text_box()  # Show the next one
		
	
