extends VBoxContainer

signal letter_pressed(letter: String)
signal enter_pressed
signal delete_press


func _on_key_pressed(letter: String) -> void:
	letter_pressed.emit(letter)

func _on_enter_pressed() -> void:
	enter_pressed.emit()

func _on_delete_pressed() -> void:
	delete_press.emit()

func on_letter_validated(usedLetters, validationResult):
	var keys = get_tree().get_nodes_in_group("keyboard") as Array[KeyboardButtons]
	for key in keys:
		var usedLetterIndex = usedLetters.find(key.name.to_lower())
		if usedLetterIndex != -1:
			key.setState(validationResult[usedLetterIndex])
