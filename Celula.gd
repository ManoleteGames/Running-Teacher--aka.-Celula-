extends RigidBody2D

signal splash
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
@export var MIN_SPEED: int # minimum speed range
@export var MAX_SPEED: int # maximum speed range
var timer
var crashed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	crashed = false
	$DisposeTimer.stop()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func get_crashed():
	return crashed
	
func Explode():
	crashed = true
	sleeping = true
	$AnimatedSprite2D.play("default")
	$DisposeTimer.start(1)
	
func _on_DisposeTimer_timeout():
	queue_free()
