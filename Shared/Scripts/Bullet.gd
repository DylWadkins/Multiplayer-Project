extends Node3D

@onready var timer: Timer = $Timer
@onready var raycast: RayCast3D = $RayCast3D

@export var lifetime := 5.0
@export var speed := 1
@export var explodes := true
@export var explosive_power := 5.5


func _ready() -> void:
	timer.wait_time = lifetime
	

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -speed)
	
	# Remove bullet on hit
	if raycast.is_colliding():

		var collider =  raycast.get_collider()
		if explodes and collider.get_parent() is Destructible:
			collider.get_parent().destroy(explosive_power)
			
		queue_free()

# Life time of the bullet
func _on_timer_timeout() -> void:
	queue_free()
