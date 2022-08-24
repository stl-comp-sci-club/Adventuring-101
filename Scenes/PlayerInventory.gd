extends Node

const NUM_INVENTORY_SLOTS = 27

var inventory = {
	0: ["Iron Sword", 1] #--> slot_index: [item_name, item_quantity]
}

func add_item (item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			#TO DO CHECK IF SLOT IS FULL
			inventory[item][1] += item_quantity
			return
			
	#item doesnt exist in inventory yet so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return
