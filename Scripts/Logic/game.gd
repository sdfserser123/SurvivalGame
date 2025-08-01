extends Node2D

@onready var inventory: Node2D = $CanvasLayer/Inventory

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("inventory"):
		if inventory.just_closed:
			inventory.just_closed = false  # reset flag
			return
		inventory.is_open = true
		inventory.initialize_inventory()
		inventory.visible = true
		get_tree().paused = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
