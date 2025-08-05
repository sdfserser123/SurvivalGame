extends CanvasLayer

@onready var inventory: Node2D = $Inventory
@onready var hotbar: Node2D = $Hotbar
@onready var crafting_bar: Control = $CraftingBar

var holding_item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("inventory"):
		if inventory.just_closed:
			inventory.just_closed = false  # reset flag
			hotbar.is_open = false
			hotbar.disable_mouse()
			return
		inventory.is_open = true
		crafting_bar.is_open = true
		hotbar.is_open = true
		crafting_bar.visible = inventory.is_open
		crafting_bar.initialize_crafting()
		inventory.initialize_inventory()
		hotbar.enable_mouse()
		hotbar.initialize_hotbar()
		inventory.visible = true
		get_tree().paused = true
	if event.is_action_pressed("scroll_up"):
		pass
	elif event.is_action_pressed("scroll_down"):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
