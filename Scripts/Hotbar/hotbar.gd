extends Node2D

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
@onready var hotbar_container: GridContainer = $HotbarContainer
@onready var slots = hotbar_container.get_children()
@onready var selected_animation: AnimatedSprite2D = $SelectedAnimation
@onready var mouse_block: ColorRect = $MouseBlock

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

		# ✅ Phải có dòng này để nhận sự kiện click chuột!
		slots[i].gui_input.connect(slot_gui_input.bind(slots[i]))
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

func slot_gui_input(event: InputEvent, slot: slotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UserInterface").holding_item.idName != slot.item.idName:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding_item(slot)

func left_click_empty_slot(slot: slotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putInSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: slotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putInSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: slotClass):
	var slot_idName = slot.item.idName
	var stackSize = int(ItemDb.ITEMS[slot_idName].stack_size)
	var able_to_add = stackSize - slot.item.item_amount

	if able_to_add == 0:
		var temp_item = slot.item

		# Cập nhật PlayerInventory
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)

		# Swap trong scene
		slot.pickFromSlot()
		slot.putInSlot(find_parent("UserInterface").holding_item)

		find_parent("UserInterface").holding_item = temp_item
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	else:
		# Gộp stack nếu chưa full
		var to_add = min(able_to_add, find_parent("UserInterface").holding_item.item_amount)
		PlayerInventory.add_item_quantity(slot, to_add)
		slot.item.add_item_quantity(to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(to_add)

		if find_parent("UserInterface").holding_item.item_amount <= 0:
			find_parent("UserInterface").holding_item.queue_free()
			find_parent("UserInterface").holding_item = null
func left_click_not_holding_item(slot: slotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func enable_mouse():
	mouse_block.mouse_filter = Control.MOUSE_FILTER_IGNORE

func disable_mouse():
	mouse_block.mouse_filter = Control.MOUSE_FILTER_STOP

func _process(delta: float) -> void:
	pass
