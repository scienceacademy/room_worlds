extends Node3D

@export var start_angle = 0

func _ready():
	$RigidBody3D.rotation_degrees.z = start_angle


func _on_area_3d_body_entered(body):
#	print("hit: ", body.name)
	if body.has_method("damage"):
		body.damage()
