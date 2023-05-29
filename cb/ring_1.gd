extends Area3D

var speed = PI/4


func _physics_process(delta):
	rotate_y(speed * delta)


func _on_body_entered(body):
#	print("hit: ", body.name)
	if body.has_method("damage"):
		body.damage()
