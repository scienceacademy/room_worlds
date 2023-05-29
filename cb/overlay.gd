extends CanvasLayer

func show_time(time):
	var min = int(time / 60)
	var sec = int(time) % 60
	var s = "%2d : %s" % [min, str(sec).pad_zeros(2)]
	$Label.text = s
