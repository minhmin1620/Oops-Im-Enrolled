extends Node2D

@export var key : Area2D
@export var keyLabel : Label
@export var bus : Area2D
@export var tryAgainLabel : Label
@export var instructionRect : ColorRect
@export var introRect : ColorRect
@export var outroRect : ColorRect

var timer
var timer2
var winable
var moveable 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key.hit.connect(collectKey)
	bus.hit.connect(displayEnd)
	keyLabel.visible = false
	tryAgainLabel.visible = false
	timer = 5
	timer2 = 5
	winable = false
	instructionRect.visible = false
	introRect.visible = true
	moveable = false
	outroRect.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !moveable:
		return
	var cam_width = get_viewport_rect().size.x / $Cam.zoom.x
	var level_width = 10000  # Example level width in world units

	$Cam.position.x = clamp($Brian.position.x, cam_width / 2, level_width - cam_width / 2)
	if (keyLabel.visible):
		timer -= delta
		print(timer)
		if timer <= 0:
			keyLabel.visible = false
	if (tryAgainLabel.visible):
		timer2 -= delta
		print(timer)
		if timer2 <= 0:
			tryAgainLabel.visible = false
func collectKey():
	print("Key is collected")
	keyLabel.visible = true
	key.visible = false
	winable = true

func displayEnd():
	outroRect.visible = true
	moveable = false
	
func endGame():
	if winable == true:
		get_tree().change_scene_to_file("res://Scene/StartScene/main.tscn")
	else:
		tryAgainLabel.visible = true
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_button_pressed() -> void:
	moveable = true
	instructionRect.visible = false


func _on_button2_pressed() -> void:
	instructionRect.visible = true
	introRect.visible = false


func _on_button3_pressed() -> void:
	endGame()
