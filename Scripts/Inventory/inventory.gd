extends Node2D

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
@onready var inventory_slots: GridContainer = $InventorySlots
var is_open = false
var just_closed = false
func _input(event: InputEvent) -> void:
	if find_parent("UserInterface").holding_item != null: 
		find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("inventory") and is_open:
		close_inventory()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].gui_input.connect(slot_gui_input.bind(slots[i]))
		slots[i].slot_index = i
		slots[i].slot_type = slotClass.SlotType.INVENTORY
	initialize_inventory()

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

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

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

func close_inventory():
	is_open = false
	visible = false
	get_tree().paused = false
	just_closed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
