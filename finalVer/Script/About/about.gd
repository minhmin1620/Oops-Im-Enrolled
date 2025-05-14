extends Control

@onready var back_button = $Panel/VBoxContainer/BackButton

func _ready():
	back_button.pressed.connect(_on_BackButton_pressed)

func _on_BackButton_pressed():
	get_tree().change_scene_to_file("res://Scene/MainMenu/main_menu.tscn")
