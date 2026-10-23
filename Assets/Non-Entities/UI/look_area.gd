extends Control

signal look(relative: Vector2)
var finger := -1

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and finger == -1 and get_global_rect().has_point(event.position):
			finger = event.index
		elif not event.pressed and event.index == finger:
			finger = -1
	elif event is InputEventScreenDrag and event.index == finger:
		look.emit(event.relative)
