extends ColorRect

@export var loseColor: Color
@export var winColor: Color
@export var alphaFactor: float = 0.4

@onready var  wordLabel = $CenterContainer/Panel/VBoxContainer/WordLabel
@onready var resultLabel = $CenterContainer/Panel/VBoxContainer/ResultLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func show_result(hasWon: bool, word: String, moveNumb: int):
	var clearColor = winColor if hasWon else loseColor
	var colorWithAlpha = Color(clearColor, alphaFactor)
	wordLabel.text = word
	wordLabel.add_theme_color_override("font_color", clearColor)
	
	var movesString = "move" if moveNumb == 1 else "moves"
	
	if hasWon:
		resultLabel.text = "You have won in " + str(moveNumb) + " " + movesString
	else:
		resultLabel.text = "You have lost"
	#resultLabel.text = "You have won in " + str(moveNumb) + " " + movesString if hasWon else "You have lost"
	color = colorWithAlpha
	show()

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_2_pressed() -> void:
	GameState.exit_minigame("res://Scene/MainWorld/main_world.tscn")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print("add something to quit the game here (escape button)")
