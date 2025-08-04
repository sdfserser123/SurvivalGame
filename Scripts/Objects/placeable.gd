class_name Placeable extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var previewing: bool = true:
	get:
		return previewing
	set(new_value):
		previewing = new_value

var can_place: bool = true:
	get:
		return can_place
	set(new_value):
		can_place = new_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
