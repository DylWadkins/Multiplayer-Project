extends Sprite3D

@export var bullet_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func shoot() -> void:
	var bullet : Node3D = bullet_scene.instantiate()
	bullet.position = self.global_position
	bullet.transform.basis = self.global_transform.basis
	add_child(bullet)
