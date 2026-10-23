extends CanvasLayer

@onready var resume_button: Button = $VBoxContainer/Resume
@onready var settings_button: Button = $VBoxContainer/Settings
@onready var quit_button: Button = $VBoxContainer/Quit


func _ready():
	visible = false
	resume_button.pressed.connect(resume)
	quit_button.pressed.connect(get_tree().quit)
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func pause():
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume():
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if InputMode.is_touch else Input.MOUSE_MODE_CAPTURED
