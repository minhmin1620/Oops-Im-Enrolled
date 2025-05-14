extends Panel

const stateToThemeVariation = ["Empty", "Incorrect", "CorrectWrongPosi", "Correct"]

var letterValue : String
@onready var label = $Label

@export var letter: String:
	get:
		return letterValue
	set(value):
		letterValue = value
		if label != null:
			label.text = value.to_upper()

@export var state: Enums.State = Enums.State.Empty

func setTileState(newState: Enums.State):
	state = newState
	theme_type_variation = stateToThemeVariation[state]
	
func _ready() -> void:
	theme_type_variation = stateToThemeVariation[state]
	if state == Enums.State.Empty:
		label.text = ""
	else:
		label.text = letter
		
	
