extends Polygon2D

func appear(value):
	visible = value
	if value: $IndicatorTimer.start()
	else: $IndicatorTimer.stop()

func _on_indicator_timer_timeout():
	if color.a == 0: 
		color.a = 1
	else:
		color.a = 0
