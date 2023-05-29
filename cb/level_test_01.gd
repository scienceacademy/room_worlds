extends Node3D

var timer = 305.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#	$FPSPlayer.position = $StartPosition.position
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta):
	timer -= delta
	if timer <= 0:
		print("game over")
		# game_over()
	$Overlay.show_time(timer)

func game_over():
	pass


func _on_fps_player_hit():
	get_tree().reload_current_scene()
