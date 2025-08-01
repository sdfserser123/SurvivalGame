extends Node2D

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
@onready var hotbar_container: GridContainer = $HotbarContainer
@onready var slots = hotbar_container.get_children()
@onready var selected_animation: AnimatedSprite2D = $SelectedAnimation

func _unhandled_input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("hotbar_1"):
		PlayerInventory.set_active_slot(0)
	elif event.is_action_pressed("hotbar_2"):
		PlayerInventory.set_active_slot(1)
	elif event.is_action_pressed("hotbar_3"):
		PlayerInventory.set_active_slot(2)
	elif event.is_action_pressed("hotbar_4"):
		PlayerInventory.set_active_slot(3)
	elif event.is_action_pressed("hotbar_5"):
		PlayerInventory.set_active_slot(4)
	elif event.is_action_pressed("hotbar_6"):
		PlayerInventory.set_active_slot(5)
	elif event.is_action_pressed("hotbar_7"):
		PlayerInventory.set_active_slot(6)
	elif event.is_action_pressed("hotbar_8"):
		PlayerInventory.set_active_slot(7)
	elif event.is_action_pressed("hotbar_9"):
		PlayerInventory.set_active_slot(8)
	elif event.is_action_pressed("hotbar_0"):
		PlayerInventory.set_active_slot(9)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInventory.connect("active_item_updated", Callable(self, "move_selector_to_slot"))
	for i in range(slots.size()):
		slots[i].slot_type = slotClass.SlotType.HOTBAR
		slots[i].slot_index = i

	move_selector_to_slot(PlayerInventory.active_item_slot)
	initialize_hotbar()

func move_selector_to_slot(slot_index: int):
	if slot_index < 0 or slot_index >= slots.size():
		return

	var slot_node = slots[slot_index]
	var global_pos = slot_node.get_global_position()
	var local_pos = to_local(global_pos)
	global_pos.x += 8
	global_pos.y += 8
	selected_animation.global_position = global_pos

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
