extends Node3D

## Spawning procedures will have access to a collection of these nodes 
## from the SpawnNodes group. They can test if a spawn is valid, and if so,
## obtain the spawn point.
##
## Class should be extended to include constraints like team spawn only,
## or allow random spawns within a region.

enum Teams {NONE, TEAM_A, TEAM_B}
enum Spawn {POINT, AREA}

@export var team: Teams = Teams.NONE
@export var spawn_type: Spawn = Spawn.POINT
@export var spawn_point : Node3D
@export var spawn_area : Area3D

@export var _occupied = false
	
func has_spawn() -> bool:
	return not _occupied

func get_spawn() -> Vector3:
	_occupied = true
	return spawn_point.global_position


func _on_spawn_area_body_entered(_body: Node3D) -> void: 
	_occupied = true


func _on_spawn_area_body_exited(_body: Node3D) -> void:
	_occupied = false
