extends Node2D

const SlotClass = preload("res://Scripts/Slot.gd")
var ItemClass = preload("res://Scenes/Item.tscn")
onready var hotbar = get_node("./HotbarSlots")
onready var slots = hotbar.get_children()



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range (slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialize_hotbar()

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
			if PlayerInventory.hotbar[i][1] == 0:
				slots[i].delete()

func _process(delta):
	initialize_hotbar()

func slot_gui_input(event:InputEvent, slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#currently holding an item
			if find_parent("Inventory UI").holding_item != null:
				if !slot.item: # place holding item to slot 
					left_click_empty_slot(slot)
				else: #swap holding item with item in slot
					if find_parent("Inventory UI").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)	
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
		elif event.button_index == BUTTON_RIGHT && event.pressed:
			# currently holding an item
			if find_parent("Inventory UI").holding_item != null:
				if !slot.item:
					right_click_empty_slot(slot)
			else:
				if slot.item != null:
					right_click_not_holding(slot)
					
func right_click_empty_slot(slot: SlotClass):
	if find_parent("Inventory UI").holding_item.item_quantity == 1:
		PlayerInventory.add_item_to_empty_slot(find_parent("Inventory UI").holding_item, slot, true)
		slot.putIntoSlot(find_parent("Inventory UI").holding_item)
		find_parent("Inventory UI").holding_item = null
	else:
		var single_item = ItemClass.instance()
		single_item.set_item(find_parent("Inventory UI").holding_item.item_name, 1)
		# single_item.item_quantity = 1
		PlayerInventory.add_item_to_empty_slot(single_item, slot, true)
		slot.putIntoSlot(single_item)
		find_parent("Inventory UI").holding_item.decrease_item_quantity(1)
		# if find_parent("Inventory UI").holding_item.item_quantity == 0:
		# 	find_parent("Inventory UI").holding_item.queue_free()
		# 	find_parent("Inventory UI").holding_item = null

func right_click_not_holding(slot: SlotClass):
	if slot.item.item_quantity == 1:
		find_parent("Inventory UI").holding_item = slot.item
		PlayerInventory.remove_item(slot, true) #remove item from inventory
		slot.pickFromSlot()
	else:
		var temp_item = ItemClass.instance()
		if slot.item.item_quantity%2 == 0:
			temp_item.set_item(slot.item.item_name, slot.item.item_quantity/2)
			slot.item.decrease_item_quantity(slot.item.item_quantity/2)
		else:
			temp_item.set_item(slot.item.item_name, (slot.item.item_quantity+1)/2)
			slot.item.decrease_item_quantity((slot.item.item_quantity+1)/2)
		# temp_item.set_item(slot.item.item_name, 1)
		find_parent("Inventory UI").holding_item = temp_item
		find_parent("Inventory UI").add_child(temp_item)
		PlayerInventory.remove_item_quantity(slot, 1, true)

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("Inventory UI").holding_item, slot, true)
	slot.putIntoSlot(find_parent("Inventory UI").holding_item)
	find_parent("Inventory UI").holding_item = null

func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot, true)
	PlayerInventory.add_item_to_empty_slot(find_parent("Inventory UI").holding_item, slot, true)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("Inventory UI").holding_item)
	find_parent("Inventory UI").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity

	if able_to_add >= find_parent("Inventory UI").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("Inventory UI").holding_item.item_quantity, true)
		slot.item.add_item_quantity(find_parent("Inventory UI").holding_item.item_quantity)
		find_parent("Inventory UI").holding_item.queue_free()
		find_parent("Inventory UI").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add, true)
		slot.item.add_item_quantity(able_to_add)
		find_parent("Inventory UI").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot, true)
	find_parent("Inventory UI").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("Inventory UI").holding_item.global_position = get_global_mouse_position()

