extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -450.0
var canmove = false

const firstDialogue: Array[String] = [
	"Ah, another beautiful day at UNB—",
	"where the buildings are historic and so is the Wi-Fi",
	"They said university would change me.",
	"They didn’t say it’d be into a sleep-deprived caffeine junkie with 500 tabs open.",
	"My quest begins at meal hall-",
	"I can't get through another day of this without a cup of crappy coffee at least."
]

const forestryGuideDialogue: Array[String] = [
	"I still don’t know what ‘silviculture’ means, but apparently I’m late for it again.",
	"Guess I’ll head to the Forestry Building before the trees file a complaint.",
]

const cellarDialogue: Array[String] = [
	"Hmm - Cellar Pub",
	"A bar sounds fun, but I have an exam tomorrow...",
	"I will go grab a spin dip for now!",
]

const exploreDialogue: Array[String] = [
	"My ramen has to be ice cold by now...",
	"You couldn't pay me $100 to eat that!",
	"I need to find something fresh to eat, but I'm getting pretty sick of meal hall...",
	"If I have to eat one more soggy meal hall burger, I might actually combust.", 
	"There has to be somewhere better to eat around here...",
]

const goToFriendDialogue: Array[String] = [
	"That kind of looks like Adam!",
	"He looks pretty stressed out...",
	"Ill go see if he is ok!",
]

const examDialogue: Array[String] = [
	"Midterm haha...",
	"Those potholes must have really shaken him up!",
	"I don't have my midterm until October 22nd.",
	"Wait a minute.....",
	"MY MIDTERM IS IN 5 MINUTES!!!",
	"I need to get to head hall, asap."
]

func _physics_process(delta: float) -> void:
	if not canmove:
		$anim.animation = "standing"
		$anim.play()
		return
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	else:
		velocity.y = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$anim.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = SPEED*-1
		$anim.flip_h = true
	
	if velocity == Vector2.ZERO:
		$anim.animation = "standing"
	else:
		$anim.animation = "walking"
	$anim.play()
	move_and_slide()
	
func setCanMove(movable: bool):
	canmove = movable
