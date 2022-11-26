extends Node2D

const SlotClass = preload("res://Scripts/Slot.gd")
onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()


# Called when the node enters the scene tree for the first time.
func _ready():

	for i in range (slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("acitve_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialize_hotbar()

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
	
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
#	PlayerInventory.remove_item(slot)
	find_parent("Inventory UI").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("Inventory UI").holding_item.global_position = get_global_mouse_position()
