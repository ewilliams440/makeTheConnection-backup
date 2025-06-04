extends Node

var score

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func level1():
	score = 0
	$Player.deboard($StartPosition.position)
	$StartTimer.start()
	set_trains(0,Vector2(366,460),Vector2(366,178),50)
	$bus.initialize(0,Vector2(366,460),Vector2(366,178),50) #surely theres a better way than adding 3 trains manually...
	set_trains(2,Vector2(62,761),Vector2(62,73),100)
	$train.initialize(2,Vector2(62,761),Vector2(62,73),100)
	set_trains(4,Vector2(149,64),Vector2(329,187),40)
	$bus2.initialize(4,Vector2(149,64),Vector2(329,187),40)
	set_trains(6,Vector2(355,481),Vector2(97,862),50)
	$bus3.initialize(6,Vector2(355,481),Vector2(97,862),50)
	$HUD.update_score(score)
	$HUD.show_message("Get To Work!")
	
func set_trains(id,p1,p2,s):
	var vel = p2-p1
	vel = vel.normalized() * s
	$Player.set_trains(vel)
	$Player.set_trains(-vel)
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$ScoreTimer.start()

func _on_hud_start_game() -> void:
	level1()

func _on_train_passenger_on(x: Variant) -> void:
	$Player.board(x)

func _on_train_passenger_off(x: Variant) -> void:
	$Player.deboard($Player.position, x)

func _ready():
	pass

func _on_train_departing() -> void:
	$Player.depart()

func _on_bus_departing() -> void:
	$Player.depart()

func _on_bus_passenger_off(x: Variant) -> void:
	$Player.deboard($Player.position, x)

func _on_bus_passenger_on(x: Variant) -> void:
	$Player.board(x)


func _on_bus_2_departing() -> void:
	$Player.depart()


func _on_bus_2_passenger_off(x: Variant) -> void:
	$Player.deboard($Player.position, x)


func _on_bus_2_passenger_on(x: Variant) -> void:
	$Player.board(x)


func _on_bus_3_departing() -> void:
	$Player.depart()


func _on_bus_3_passenger_off(x: Variant) -> void:
	$Player.deboard($Player.position, x)


func _on_bus_3_passenger_on(x: Variant) -> void:
	$Player.board(x)
