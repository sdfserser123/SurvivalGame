extends CanvasLayer

@onready var inventory: Node2D = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("inventory"):
		if inventory.just_closed:
			inventory.just_closed = false  # reset flag
			return
		inventory.is_open = true
		inventory.initialize_inventory()
		inventory.visible = true
		get_tree().paused = true
	if event.is_action_pressed("scroll_up"):
		pass
	elif event.is_action_pressed("scroll_down"):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
