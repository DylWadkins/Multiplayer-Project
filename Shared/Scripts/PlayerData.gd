class_name PlayerData

var _id
var id : int:
	get: return id
	set(val): push_error("You may not set the player id.")

var _name
var name : String:
	get: return _name
	set(val): push_error("You may not set the player name.")

var _health
var health : int:
	get: return _health
	set(val): _health = val
		
var _score
var score : int:
	get:  return score
	set(val): _score = val

# Constructor
func _init(p_id: int, p_name: String):
	_id = p_id
	_name = p_name if p_name else "Player"
	_health = 100
	_score = 0

func _to_string():
	return "ID: %s, NAME: %s, HP: %s, SCORE: %s" % [_id,_name,_health,_score]
