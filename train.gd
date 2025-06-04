extends Area2D

signal passenger_on(x)
signal passenger_off(x)
signal departing

var velocity = Vector2.ZERO
var travel = 1
var oldtravel = 1
var p1 = Vector2.ZERO
var p2 = Vector2.ZERO
var speed = 50
var id = -1 #train id to keep track of speed and route in other nodes
var tr = 2 #trainstop rounding, how close you have to be to the stop to turn around

func initialize(train_id,stop1,stop2,s):
	id = train_id
	p1 = stop1
	p2 = stop2
	speed = s
	position = p1
	print("initialized train ",id)

func _process(delta):
	if(travel==1):
		velocity = p2-position
	elif(travel==-1):
		velocity = p1-position
	else:
		velocity.x = 0
		velocity.y = 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	$AnimatedSprite2D.play()
	
	position += velocity * delta
	#position = position.clamp(p1,p2)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "default"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	if(travel==1 && abs(p2.x-position.x)<tr && abs(p2.y-position.y)<tr):
		passenger_off.emit(id)
		print("train ",id," reached p2")
		$BoardingTimer.start()
		oldtravel = travel
		travel = 0
		$CollisionShape2D.disabled = false
		
	elif(travel==-1 && abs(p1.x-position.x)<tr && abs(p1.y-position.y)<tr):
		passenger_off.emit(id+1)
		print("train ",id," reached p2")
		$BoardingTimer.start()
		oldtravel = travel
		travel = 0
		$CollisionShape2D.disabled = false

func _ready():
	pass

func _on_body_entered(_body):
	if(travel==1):
		passenger_on.emit(id)
	elif(travel==-1):
		passenger_on.emit(id+1)
	elif(oldtravel==1):
		passenger_on.emit(id+1)
	else:
		passenger_on.emit(id)
	print("passenger got on train ",id)

func _on_boarding_timer_timeout() -> void:
	departing.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	travel = -oldtravel
	print("train ",id," now leaving in direction ",travel)
