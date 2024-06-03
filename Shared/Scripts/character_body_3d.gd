extends CharacterBody3D
@onready var LeftHand := $Head/Arms/LeftHand
@onready var RightHand := $Head/Arms/RightHand
@onready var head := $Head
@onready var camera := $Head/Camera3D
@export var nameLabel : Label3D

var id := 0
var SPEED = 5.0
var RUN_SPEED = 7.0
var JUMP_VELOCITY = 4.5
enum States {Walk, Run, Jump, Fall}
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			print("rotating ", id)
			head.rotate_y(-event.relative.x * 0.001)
			camera.rotate_x(-event.relative.y * 0.001)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-10), deg_to_rad(10))

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(id)
	camera.current = is_authority()
	nameLabel.text = "%s (%d)" % ["Player", id]
	
	
func _physics_process(delta: float) -> void:
	#$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit();
		
	if Input.is_action_pressed("Sprint"):
		SPEED = 7.5
	elif Input.is_action_just_released("Sprint"):
		SPEED = 5.0
		
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func is_authority() -> bool:
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
