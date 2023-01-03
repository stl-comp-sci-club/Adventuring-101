extends Node

signal active_item_updated

const SlotClass = preload("res://Scripts/Slot.gd")
const ItemClass = preload("res://Scripts/Item.gd")
const NUM_INVENTORY_SLOTS = 27
const NUM_HOTBAR_SLOTS = 9

var inventory = {
	0: ["Iron Sword", 1], #--> slot_index: [item_name, item_quantity]
	1: ["Iron Sword", 1], #--> slot_index: [item_name, item_quantity]
	20: ["Magic Wand", 1], #--> slot_index: [item_name, item_quantity]
}

var hotbar = {
	0: ["Iron Sword", 1], #--> slot_index: [item_name, item_quantity]
	1: ["Iron Sword", 1] #--> slot_index: [item_name, item_quantity]
}

var active_item_slot = 0

func _input(event): # temp, do not keep
	if event.is_action_pressed("ui_home"):
		print("Update " + str(hotbar))

	if event is InputEventKey and event.is_pressed():
		match event.scancode:
			KEY_1:
				if active_item_slot != 0:
					active_item_slot = 0
					emit_signal("active_item_updated")
			KEY_2:
				if active_item_slot != 1:
					active_item_slot = 1
					emit_signal("active_item_updated")
			KEY_3:
				if active_item_slot != 2:
					active_item_slot = 2
					emit_signal("active_item_updated")
			KEY_4:
				if active_item_slot != 3:
					active_item_slot = 3
					emit_signal("active_item_updated")
			KEY_5:
				if active_item_slot != 4:
					active_item_slot = 4
					emit_signal("active_item_updated")
			KEY_6:
				if active_item_slot != 5:
					active_item_slot = 5
					emit_signal("active_item_updated")
			KEY_7:
				if active_item_slot != 6:
					active_item_slot = 6
					emit_signal("active_item_updated")
			KEY_8:
				if active_item_slot != 7:
					active_item_slot = 7
					emit_signal("active_item_updated")
			KEY_9:
				if active_item_slot != 8:
					active_item_slot = 8
					emit_signal("active_item_updated")
	




func add_item(item_name, item_quantity):
	print("Before " + str(inventory))
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			print("item: ", item)
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				#update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				#update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
	
	#item doesnt exist in inventory yet so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			#update_slot_visual(i, inventory[i][0], inventory[i][1])
			print("After " + str(inventory))
			return

#func update_slot_visual(slot_index, item_name, new_quantity):
	#var slot = get_tree().root.get_node("/root/PlayerInventory/GridContainer/Slot" + str(slot_index + 1))
	#if slot.item != null: 
	#	slot.item.set_item(item_name, new_quantity)
	#else:
	#	slot.initalize_item(item_name, new_quantity) 



func remove_item(slot: SlotClass, is_hotbar: bool = false):
	if is_hotbar:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)
	print("Item removed: " + str(inventory))
	print("Item: " + str(slot))

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		print(slot.slot_index)
		print(item.item_name, item.item_quantity)
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add

func remove_item_quantity(slot: SlotClass, quantity_to_remove: int, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] -= quantity_to_remove
	else:
		inventory[slot.slot_index][1] -= quantity_to_remove
		

func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else: 
		active_item_slot -= 1
	emit_signal("active_item_updated")
