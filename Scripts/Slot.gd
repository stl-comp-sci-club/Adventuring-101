extends Panel

var default_tex = preload("res://Assets/inventory/inventoryslot.png")
var empty_tex = preload("res://Assets/inventory/inventoryslot.png")
var selected_tex = preload("res://Assets/inventory/slotfilled.png")

var ItemClass = preload("res://Scenes/Item.tscn")
var item = null
var slot_index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

func _ready():
	refresh_style()
	
func refresh_style():
	if SlotType.HOTBAR == slot_type and  PlayerInventory.active_item_slot == slot_index:
		get_stylebox("panel", "").set_texture(selected_tex)
	elif item == null:
		get_stylebox("panel", "").set_texture(empty_tex)
	else: 
		get_stylebox("panel", "").set_texture(default_tex)
		
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory UI")
	inventoryNode.add_child(item)
	item = null
	refresh_style()

func delete():
	if item != null:
		remove_child(item)
		item = null
		refresh_style()

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory UI")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
