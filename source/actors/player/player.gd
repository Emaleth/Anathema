extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var current_speed := 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var step_time := 0.05
var footstep_sounds := [
	preload("res://assets/sounds/footsteps/footstep00.ogg"),
	preload("res://assets/sounds/footsteps/footstep01.ogg"),
	preload("res://assets/sounds/footsteps/footstep02.ogg"),
	preload("res://assets/sounds/footsteps/footstep06.ogg"),
	preload("res://assets/sounds/footsteps/footstep05.ogg"),
	preload("res://assets/sounds/footsteps/footstep04.ogg"),
	preload("res://assets/sounds/footsteps/footstep03.ogg"),
	preload("res://assets/sounds/footsteps/footstep08.ogg"),
	preload("res://assets/sounds/footsteps/footstep09.ogg"),
	preload("res://assets/sounds/footsteps/footstep07.ogg"),
]

@onready var head := $Head
@onready var footsteps_audio := $FootstepsAudio
@onready var breathing_audio := $Head/BreathingAudio
@onready var footstep_timer := $FootstepTimer



func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	footstep_timer.timeout.connect(footsteps)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * Settings.mouse_sensitivity * -1)
		rotation_degrees.y = wrap(rotation_degrees.y, -180, 180)
		head.rotate_x(event.relative.y * Settings.mouse_sensitivity * -1)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)


func footsteps():
	if is_on_floor() && velocity.length() > 0.0:
		footsteps_audio.stream = footstep_sounds.pick_random()
		footsteps_audio.play()
	footstep_timer.start(step_time * current_speed)

