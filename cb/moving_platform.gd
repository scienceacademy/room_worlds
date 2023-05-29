@tool
extends Node3D

@export var movement = Vector3(0, 0, -5):
	set = set_movement
@export var cycle_time = 4.0
@export var wait_time = 1.0

var dir = 1

@onready var body = $AnimatableBody3D
@onready var endpoint = $Endpoint
	
func set_movement(value):
	movement = value
	if Engine.is_editor_hint():
		endpoint.show()
		endpoint.position = movement 

func _ready():
	if not Engine.is_editor_hint():
		endpoint.hide()
		move()
		
func move():
	var tween = create_tween()
	if dir == 1:
		tween.tween_property(body, "position", movement, cycle_time).from(Vector3.ZERO)
	else:
		tween.tween_property(body, "position", Vector3.ZERO, cycle_time).from(movement)
	await tween.finished
	await get_tree().create_timer(wait_time).timeout
	dir = -dir
	move()
