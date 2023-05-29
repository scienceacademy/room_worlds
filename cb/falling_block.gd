extends Node3D

@export var delay = 0.4
@export var reset = 1.5

var falling = false

func fall():
	if falling:
		return
	falling = true
	await get_tree().create_timer(delay).timeout
	$AnimatableBody3D/CollisionShape3D.set_deferred("disabled", true)
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property($AnimatableBody3D, "position:y", -40, reset)
	await tween.finished
	$AnimatableBody3D.hide()
	await get_tree().create_timer(reset).timeout
	$AnimatableBody3D.position.y = 0
	$AnimatableBody3D/CollisionShape3D.disabled = false
	$AnimatableBody3D.show()
	falling = false
