extends Area3D

@export var destination : PackedScene



func _on_body_entered(body):
	if body.name == "FPSPlayer":
		print(destination)
		get_tree().change_scene_to_packed(destination)
