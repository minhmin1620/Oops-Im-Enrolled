extends Node2D

const endOfYearDialogue: Array[String] = [
	"Oh yay... I actually made it to the end of the semester!",
	"What a wild first year — midterms, ramen nights, and running from profs.",
	"Cheers to late-night cramming, awkward group projects, and surviving meal hall!",
	"First year: complete. Time to reward myself with something cold and bubbly 🍻."
]

func _process(delta: float) -> void:
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
