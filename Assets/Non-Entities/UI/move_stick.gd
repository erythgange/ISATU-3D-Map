extends Control

@export var radius := 120.0
var finger := -1
var center := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and finger == -1 and get_global_rect().has_point(event.position):
			finger = event.index
			center = event.position
		elif not event.pressed and event.index == finger:
			finger = -1
			_apply(Vector2.ZERO)
	elif event is InputEventScreenDrag and event.index == finger:
		_apply(((event.position - center) / radius).limit_length(1.0))

func _apply(v: Vector2) -> void:
	_axis("left", "right", v.x)
	_axis("up", "down", v.y)

func _axis(neg: String, pos: String, val: float) -> void:
	if val < 0.0:
		Input.action_press(neg, -val)
		Input.action_release(pos)
	elif val > 0.0:
		Input.action_press(pos, val)
		Input.action_release(neg)
	else:
		Input.action_release(neg)
		Input.action_release(pos)
