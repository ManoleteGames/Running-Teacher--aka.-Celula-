extends Area2D

signal crash
signal splash
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screensize  # size of the game window
var colobject

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Floor_body_entered(body):
	#body.hide()
	var name = body.get_name()
	if name.find("Cross",0) != -1:
		#body.hide()
		#body.queue_free()
		body.Crass()
		emit_signal("crash")
	if name.find("Celula",0) != -1:	
		#body.hide()
		#body.AnimatedSprite.play()
		body.Explode()
		emit_signal("splash")
