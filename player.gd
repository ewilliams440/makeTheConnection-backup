extends CharacterBody2D

@export var speed = 30
@export var map_size = Vector2(450,950) #actual map size - 50 for borders
var train = -1
var departed = false
var trainlist_velocity = []

func _ready():
	pass

func _process(delta):
	var velocity = Vector2.ZERO
	if(departed):
		velocity = trainlist_velocity[train]
		position += velocity * delta
		if (Input.is_action_just_pressed("action")):
			deboard()
	elif(train<0):
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
		position += velocity * delta
		position = position.clamp(Vector2(50,50), map_size)
			
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "right"
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "down"
		elif velocity.y < 0:
			$AnimatedSprite2D.animation = "up"

func deboard(pos = position, trainid = -1):
	if(trainid==train):
		position = pos
		departed = false
		show()
		if(train>=0):
			$TrainTimeout.start()
		train = -1
	
func board(t):
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	train = t
	
func depart():
	if(train>=0):
		departed = true
	
func set_trains(v):
	trainlist_velocity.append(v)

func _on_train_timeout_timeout() -> void:
	print("(PLAYER) turning collisionshape back on")
	$CollisionShape2D.disabled = false
