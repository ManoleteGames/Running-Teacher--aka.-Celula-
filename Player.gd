extends Area2D

signal hit
signal dead
signal eat
signal superhero
signal restart
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
@export var SPEED: int  # how fast the player will move (pixels/sec)
var screensize  # size of the game window
var colobject
var idle
var death
var power
var shero

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screensize = get_viewport_rect().size
	idle = true
	death = false
	shero = false
	power = 1
	$AnimatedSprite2D.set("animation","level1")
	#hide()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var velocity = Vector2() # the player's movement vector
	
	if idle == false:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1        
			$AnimatedSprite2D.flip_h = true
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			$AnimatedSprite2D.flip_h = false
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.set("frame",0)
		position += velocity * delta
		position.x = clamp(position.x, -15, +15)
	
	#Player animation
	if power == 1 && death == false:
		$AnimatedSprite2D.set("animation","level1")
	if power == 2:
		$AnimatedSprite2D.set("animation","level1")
	if power == 3:
		$AnimatedSprite2D.set("animation","level2")
	if power == 4:
		$AnimatedSprite2D.set("animation","level3")
	if power == 5:
		$AnimatedSprite2D.set("animation","level4")
	if power == 6:
		idle = true
		shero = true
		$AnimatedSprite2D.set("animation","superhero")
		$AnimatedSprite2D.play()
		if $AnimatedSprite2D.frame == 20:
			shero = false
			idle = false
			power = 1
			emit_signal("restart")

func _on_Player_body_entered(body):
	
	var name = body.get_name()
	
	if name.find("Cross",0) != -1 && idle == false:
		var disabled = body.get_crashed()
		if disabled:
			#do nothing
			death = false
		else:
			body.queue_free()
			if power > 1:
				power -= 1
				emit_signal("hit")
			else:
				idle = true
				death = true
				$AnimatedSprite2D.play("dead")
				$CollisionShape2D.set_deferred("disabled", true) 
				emit_signal("dead")

	if name.find("Celula",0) != -1 && idle == false:
		body.queue_free()
		
		emit_signal("eat")
		
		if power < 6:
			power += 1
		
		if power == 6:
			emit_signal("superhero")

func start(pos):
	$AnimatedSprite2D.set("animation","level1")
	death = false
	idle = false
	shero = false
	position = pos
	show()
	$CollisionShape2D.disabled = false

func getPower():
	return power
	
func setPower(_power):
	power = _power
