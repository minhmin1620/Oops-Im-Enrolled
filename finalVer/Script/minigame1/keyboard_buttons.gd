extends Button

class_name KeyboardButtons
@export var letter: String
@export var state : Enums.State = Enums.State.Empty

const stateToThemeVariation = ["Available", "Used", "CorrectWrongPosi", "Correct"]

func _ready():
	name = letter
	theme_type_variation = stateToThemeVariation[state]
	text = letter

func setState(newState: Enums.State):
	if newState == Enums.State.Incorrect:
		disabled = true
	if state != Enums.State.Correct:
		state = newState
		theme_type_variation = stateToThemeVariation[state]
		
	
	
