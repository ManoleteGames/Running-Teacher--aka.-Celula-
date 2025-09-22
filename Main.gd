extends Node

@export var Celula: PackedScene
@export var Cross: PackedScene
var CelulaScene = preload("res://Celula.tscn") # will load when parsing the script
var CrossScene = preload("res://Cross.tscn") # will load when parsing the script
var Celula_child
var Cross_child
var score
var CrossTime
var CelulaTime
var dead
var power
var scene_array = []
var red_inst=[]
var item
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	SetPowerBar(1)
	score = 0
	power = 1
	dead = false
	$Background/Blackboard/lblPointsTitle.visible = false
	randomize()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	power = $Background/Player.getPower()
	SetPowerBar(power)

func new_game():
	dead = false
	score = 0
	power = 1
	CrossTime = 1.0
	CelulaTime = 3.0
	$CrossTimer.set_wait_time(CrossTime)
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$StartTimer.start()
	$Background/Player.start($Background/StartPosition.position)	
	$Musica.play()

func game_over():
	$CelulaTimer.stop()
	$CrossTimer.stop()
	$StartTimer.stop()
	$GameTimer.stop()
	$HUD.show_game_over()
	$GameOver.play()

func _on_CelulaTimer_timeout():
	 # choose a random location on Path2D
	$Path3D/SpawnLocation.set_progress(randi())
	
	# create a Mob instance and add it to the scene
	Celula_child = CelulaScene.instantiate()
	add_child(Celula_child)
	# set the mob's position to a random location
	Celula_child.position = $Path3D/SpawnLocation.position
	Celula_child.name = "Celula"
	Cross_child.add_to_group("celulas")

func _on_StartTimer_timeout():
	$Background/Blackboard/lblPointsTitle.visible = true;
	$HUD/ScoreLabel.visible = true;
	$CelulaTimer.start()
	$CrossTimer.start()
	$GameTimer.start()

func _on_CrossTimer_timeout():
	# choose a random location on Path2D
	$Path3D/SpawnLocation.set_progress(randi())
	# create a Mob instance and add it to the scene
	Cross_child = CrossScene.instantiate()
	add_child(Cross_child)
	# set the mob's position to a random location
	Cross_child.position = $Path3D/SpawnLocation.position
	Cross_child.name = "Cross"	
	Cross_child.add_to_group("crosses")

func _on_Player_eat():
	$Coin.play()

func _on_Player_hit():
	$Hit.play()

func _on_Player_dead():
	dead = true
	game_over()

func SetPowerBar(num):
	if num == 1:
		$Background/PowerBar.set("animation","Level_1")
	if num == 2:
		$Background/PowerBar.set("animation","Level_2")
	if num == 3:
		$Background/PowerBar.set("animation","Level_3")
	if num == 4:
		$Background/PowerBar.set("animation","Level_4")
	if num == 5:
		$Background/PowerBar.set("animation","Level_5")
	if num == 6:
		$Background/PowerBar.set("animation","MaxPower")
		$Background/PowerBar.play()

func _on_GameTimer_timeout():
	#decrease the cross timer each GameTimer timeout
	CrossTime -= 0.1
	if CrossTime >= 0.1:
		$CrossTimer.set_wait_time(CrossTime)
	CelulaTime += 0.1
	$CelulaTimer.set_wait_time(CelulaTime)

func _on_Floor_crash():
	if dead == false:
		score += 1
		$HUD.update_score(score)

func _on_Floor_splash():
	pass # Replace with function body.

func _on_Player_super():
	#pass # Replace with function body.
	$CelulaTimer.stop()
	$CrossTimer.stop()
	#set_physics_process(false)
	#var children = get_children()
	#var child_count = get_child_count()
	var crosses = get_tree().get_nodes_in_group("crosses")
	for _i in crosses:
		score += 10
		$HUD.update_score(score)
		_i.Explode()
	
	var celulas =get_tree().get_nodes_in_group("celulas")

func _on_HUD_move_left():
	$Background/Left.frame = 1

func _on_HUD_release_left():
	$Background/Left.frame = 0

func _on_HUD_move_right():
	$Background/Right.frame = 1

func _on_HUD_release_right():
	$Background/Right.frame = 0

func _on_Player_restart():
	CrossTime += 0.1
	CelulaTime -= 0.1
	$CelulaTimer.start()
	$CrossTimer.start()
