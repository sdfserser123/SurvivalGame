extends Node

signal active_item_updated(slot_index)

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
const ItemClass = preload("res://Scripts/Items/item.gd")

@onready var player = get_tree().get_first_node_in_group("Player")

const NUM_INVENTORY_SLOTS = 30
const NUM_HOTBAR_SLOTS = 10

var inventory = {
	0: ["wooden_axe", 1],
	15: ["wood_log", 15]
}

var hotbar = {
	1: ["wooden_axe", 1]
}

var active_item_slot = 0

func add_item(idName, item_amount):
	for item in inventory:
		if inventory[item][0] == idName:
			var stackSize = int(ItemDb.ITEMS[idName].stack_size)
			var able_to_add = stackSize - inventory[item][1]
			if able_to_add >= item_amount:
				inventory[item][1] += item_amount
				return
			else:
				inventory[item][1] += able_to_add
				item_amount = item_amount - able_to_add
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [idName, item_amount]
			return

func remove_item(slot: slotClass):
	if slot.slot_type == slotClass.SlotType.HOTBAR:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: slotClass):
	if slot.slot_type == slotClass.SlotType.HOTBAR:
		hotbar[slot.slot_index] = [item.idName, item.item_amount]
	else:
		inventory[slot.slot_index] = [item.idName, item.item_amount]
	
func add_item_quantity(slot: slotClass, quantity_to_add: int):
	if slot.slot_type == slotClass.SlotType.HOTBAR:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add

func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	player.update_current_item()
	emit_signal("active_item_updated", active_item_slot) # ✅ FIXED

func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	player.update_current_item()
	emit_signal("active_item_updated", active_item_slot) # ✅ FIXED

func set_active_slot(index: int):
	if index != active_item_slot:
		active_item_slot = index
		player.update_current_item()
		emit_signal("active_item_updated", active_item_slot)
