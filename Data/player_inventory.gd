extends Node

const slotClass = preload("res://Scripts/Inventory/inventory_slot.gd")
const ItemClass = preload("res://Scripts/Items/item.gd")

const NUM_INVENTORY_SLOTS = 30

var inventory = {
	0: ["wooden_axe", 1],
	15: ["wood_log", 15]
}

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
	inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: slotClass):
	inventory[slot.slot_index] = [item.idName, item.item_amount]
	
func add_item_quantity(slot: slotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add
