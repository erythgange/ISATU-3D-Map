extends Node

signal mode_changed(is_touch: bool)
var is_touch := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Mobile starts in touch mode; desktop waits for the first touch
	_set_touch(OS.has_feature("mobile"))

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_set_touch(true)
	elif event is InputEventKey or event is InputEventMouseButton \
			or (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		_set_touch(false)

func _set_touch(value: bool) -> void:
	if value == is_touch and is_node_ready():
		return
	is_touch = value
	if not get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if is_touch else Input.MOUSE_MODE_CAPTURED
	mode_changed.emit(is_touch)
