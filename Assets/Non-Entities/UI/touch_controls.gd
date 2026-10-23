extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # pause button must work while paused
	InputMode.mode_changed.connect(func(t): visible = t)
	visible = InputMode.is_touch
