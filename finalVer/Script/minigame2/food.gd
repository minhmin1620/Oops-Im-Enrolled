extends Area2D

signal hit

var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number = randi() % 5 + 1
	if(random_number == 1):
		$AnimatedSprite2D.animation = "food1"
	elif(random_number == 2):
		$AnimatedSprite2D.animation = "food2"
	else:
		$AnimatedSprite2D.animation = "coffee"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += 0.02

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Brian") and not collected:
		hit.emit()
		self.visible = false
		collected = true
	
