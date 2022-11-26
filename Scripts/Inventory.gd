extends Node2D

const SlotClass = preload("res://Scripts/Slot.gd")
onready var inventory_slots = $GridContainer


func _ready():
	##'''
	##This function does this...
	##return type
	##parameteres
	##'''
	var slots = inventory_slots.get_children()
	for i in range (slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	initialize_inventory()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
	
func slot_gui_input(event:InputEvent, slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#currently holding an item
			if find_parent("Inventory UI").holding_item != null: # temp, do not keep
				if !slot.item: # place holding item to slot # not yet 
					left_click_empty_slot(slot) 
				else: #swap holding item with item in slot
					if find_parent("Inventory UI").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item != null:
				print("picked up")
				left_click_not_holding(slot)
				
# warning-ignore:unused_argument
func _input(event):
	if find_parent("Inventory UI").holding_item:
		find_parent("Inventory UI").holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("Inventory UI").holding_item, slot) # breaks here
	slot.putIntoSlot(find_parent("Inventory UI").holding_item)
	find_parent("Inventory UI").holding_item = null

func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("Inventory UI").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("Inventory UI").holding_item)
	find_parent("Inventory UI").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity

	if able_to_add >= find_parent("Inventory UI").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("Inventory UI").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("Inventory UI").holding_item.item_quantity)
		find_parent("Inventory UI").holding_item.queue_free()
		find_parent("Inventory UI").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("Inventory UI").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass): # not culprit
	find_parent("Inventory UI").holding_item = slot.item # already broken (slot.item is already broken)
	PlayerInventory.remove_item(slot) 
	slot.pickFromSlot() 
	find_parent("Inventory UI").holding_item.global_position = get_global_mouse_position()
