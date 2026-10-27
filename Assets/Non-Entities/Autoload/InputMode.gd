extends Node

enum Mode { KEYBOARD_MOUSE, TOUCH }
signal mode_changed(mode: Mode)

var mode: Mode = Mode.KEYBOARD_MOUSE

var is_touch: bool:
	get: return mode == Mode.TOUCH

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_set_mode(Mode.TOUCH if OS.has_feature("mobile") else Mode.KEYBOARD_MOUSE, true)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_set_mode(Mode.TOUCH)
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		_set_mode(Mode.KEYBOARD_MOUSE)
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debugButton"):
		# sets mode to touch if mobile, keyboard_mouse if pc. and force it
		_set_mode(Mode.TOUCH if OS.has_feature("mobile") else Mode.KEYBOARD_MOUSE, true) 

func _set_mode(new_mode: Mode, force := false) -> void:
	if new_mode == mode and not force:
		return
	mode = new_mode
	# release held touch actions so nothing gets stuck
	for a in ["left", "right", "up", "down"]:
		Input.action_release(a)
	if not get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if is_touch else Input.MOUSE_MODE_CAPTURED
	mode_changed.emit(mode)
