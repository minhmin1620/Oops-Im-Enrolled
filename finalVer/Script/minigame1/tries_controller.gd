extends VBoxContainer

@onready var wordpool = %WordPool
@onready var keyboard = %Keyboard
@onready var validationAlert = %ValidationAlert
@onready var resultUi = %ResultUi
@onready var rows: Array[HBoxContainer] = [
	$Row,
	$Row2,
	$Row3,
	$Row4,
	$Row5
]


var currRow = 0
var currLetterIndex = -1
var isFilled = false
var letters
var letterTiles

var wordGuess = ""

func _ready():
	wordGuess = wordpool.pickWord()

func _on_keyboard_enter_pressed() -> void:
	var isLongEnough = validate_length()
	if !isLongEnough:
		return
	
	letterTiles = rows[currRow].get_children()
	letters = letterTiles.map(func (c): return c.letter)
	var wordToCheck = "".join(letters).to_upper()
	#print(wordToCheck)
	#print(currLetterIndex)
	if wordpool.checkWord(wordToCheck):
		on_word_valid(wordToCheck, letters)
	else:
		validationAlert.show_with_text("WORD DOESN'T EXIST")
	
func on_word_valid(wordToCheck: String, letters):
	var validationResult = validate_word(wordGuess, letters)
	
	for i in letterTiles.size():
		letterTiles[i].setTileState(validationResult[i])
		
	keyboard.on_letter_validated(letters, validationResult)
	
	if validationResult.all(func (r): return  r == Enums.State.Correct):
		on_win()
	else:
		currRow += 1
		currLetterIndex = -1
	
	if currRow == rows.size():
		on_lose()

func validate_word(wordToCheck: String, letters) -> Array[Enums.State]:
	var validationResults: Array[Enums.State] = []
	for i in letters.size():
		var currLetter = letters[i].to_upper()
		if wordToCheck.contains(currLetter):
			var letterIndexInWord = wordToCheck.findn(currLetter)
			if letterIndexInWord == i:
				validationResults.append(Enums.State.Correct)
			else:
				letterIndexInWord = wordToCheck.findn(currLetter, i)
				if letterIndexInWord == i:
					validationResults.append(Enums.State.Correct)
				else:
					validationResults.append(Enums.State.CorrectWrongPosi)
		else:
			validationResults.append(Enums.State.Incorrect)
	return validationResults
	


func _on_keyboard_delete_press() -> void:
	if currLetterIndex >= 0:
		rows[currRow].get_child(currLetterIndex).letter = ""
		currLetterIndex -= 1


func _on_keyboard_letter_pressed(letter: String) -> void:
	if currLetterIndex < 4:
		currLetterIndex += 1
	
	if currLetterIndex <= 4:
		rows[currRow].get_child(currLetterIndex).letter = letter

func validate_length():
	if currLetterIndex == 4:
		return true
	validationAlert.show_with_text("NOT ENOUGH LETTERS")
	return false
	
func on_win():
	resultUi.show_result(true,wordGuess,currRow+1)

func on_lose():
	resultUi.show_result(false,wordGuess,-1)
	
func disconnectKeyboard():
	keyboard.delete_pressed.disconnect(_on_keyboard_delete_press)
	keyboard.enter_pressed.disconnect(_on_keyboard_enter_pressed)
	keyboard.letter_pressed.disconnect(_on_keyboard_letter_pressed)
