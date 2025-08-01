extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_weapon_id():
	return get_parent().current_weapon_id

func get_weapon_damage():
	return get_parent().current_attack_damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
