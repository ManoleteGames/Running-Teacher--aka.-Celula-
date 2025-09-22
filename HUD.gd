extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal start_game
signal move_right
signal move_left
signal release_right
signal release_left

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$StartButton.show()
	$MessageLabel.text = "Running\nteacher\n\n<aka Celula>"
	$MessageLabel.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_RightTouchButton_pressed():
	emit_signal("move_right")

func _on_LeftTouchButton_pressed():
	emit_signal("move_left")

func _on_LeftTouchButton_released():
	emit_signal("release_left")

func _on_RightTouchButton_released():
	emit_signal("release_right")
