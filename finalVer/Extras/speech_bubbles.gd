extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()

func _ready():
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	add_theme_constant_override("margin_left", 12)
	add_theme_constant_override("margin_right", 12)
	add_theme_constant_override("margin_top", 8)
	add_theme_constant_override("margin_bottom", 8)

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display

	# Wait for size to update before applying constraints
	await resized
	
	# Limit bubble width and enable wrapping if necessary
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized  # Wait twice for label reflow
		custom_minimum_size.y = size.y

	# Position bubble to the left of the character and expand only to the right
	# You can tweak the +8 and -24 to suit your visual needs
	global_position.x += 8
	global_position.y -= size.y + 24

	# Reset label for letter-by-letter animation
	label.text = ""
	letter_index = 0
	_display_letter()

	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
