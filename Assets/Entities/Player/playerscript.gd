extends CharacterBody3D

@export var walk_speed := 5.0
@export var fly_speed := 20.0
@export var mouse_sens := 0.003
var is_flying := true

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	elif event.is_action_pressed("space"):
		is_flying = !is_flying

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var move := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed := fly_speed if is_flying else walk_speed

	# horizontal
	var target_xz := Vector2(move.x, move.z) * speed
	var weight := 1.0 if move != Vector3.ZERO else delta * 4.0
	velocity.x = lerp(velocity.x, target_xz.x, weight)
	velocity.z = lerp(velocity.z, target_xz.y, weight)

	# vertical
	if is_flying:
		var vertical := Input.get_axis("fall", "rise")
		velocity.y = lerp(velocity.y, vertical * speed * 0.5, 1.0 if vertical != 0.0 else delta * 4.0)
	elif not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	move_and_slide()
