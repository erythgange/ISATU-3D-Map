extends CharacterBody3D


var move_speed : float = 20.0
var mouse_sens : float = 0.01
var is_flying  : bool = true

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if event is InputEventKey:
		if Input.is_action_just_pressed("space"):
			is_flying = !is_flying #toggle
			
		
		

func _physics_process(delta: float) -> void:
		
	
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var vertical := Input.get_axis("fall", "rise")/2
		var direction := (head.transform.basis * Vector3(input_dir.x, vertical, input_dir.y))
		
		if direction:
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
			velocity.y = direction.y * move_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 4)
			velocity.y = lerp(velocity.y, direction.y * move_speed, delta * 4)
			velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 4)
			#velocity.z = move_toward(velocity.z, 0, friction * delta)
			#if is_flying: velocity.y = move_toward(velocity.y, 0, friction * delta)
		
		# if on ground, and not on floor, be affected by gravity
		if not is_flying and not is_on_floor(): 
			velocity += get_gravity() * delta
				
		move_and_slide()
		
