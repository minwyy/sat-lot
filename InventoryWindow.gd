extends Control

@export var inventory_data: InventoryData
var current_dragged_item_data: Dictionary

func _process(delta: float) -> void:
	if not has_node("ItemDrag"):
		return
	get_node("ItemDrag").position = get_global_mouse_position() - get_node("ItemDrag").size / 5
		
func _ready() -> void:
	update_inventory_data()
	connect_signals()

func connect_signals() -> void:
	GlobalSignals.UpdateInventory.connect(update_inventory_data);

func update_inventory_data() -> void:
	for slot in %SlotGroup.get_children():
		slot.queue_free()
	
	for item_data in inventory_data.item_data:
		var new_slot = preload("res://Slot.tscn").instantiate()
		new_slot.current_item = item_data
		%SlotGroup.add_child(new_slot)
		
func _input(event: InputEvent) -> void:

	if event.is_action_pressed("mouse_left"):
		var hovered_node = get_viewport().gui_get_hovered_control()
		if hovered_node is Slot:
			var current_index = hovered_node.get_index()
			if not inventory_data.item_data[current_index]:
				return
			create_drag_item(current_index)
			inventory_data.item_data[current_index] = null
			GlobalSignals.UpdateInventory.emit()
	if event.is_action_released("mouse_left"):
		var hovered_node = get_viewport().gui_get_hovered_control()
		var item = current_dragged_item_data.get("Item")
		var index = current_dragged_item_data.get("Index")
		if has_node("ItemDrag"):
			delete_dragged_item() 
		if not current_dragged_item_data:
			return
		if not hovered_node is Slot or inventory_data.item_data[hovered_node.get_index()]:
			inventory_data.item_data[index] = item
			GlobalSignals.UpdateInventory.emit()
			return
		inventory_data.item_data[hovered_node.get_index()] = item
		current_dragged_item_data.clear()
		GlobalSignals.UpdateInventory.emit()
	
func delete_dragged_item() -> void:
	get_node("ItemDrag").queue_free()
	
func create_drag_item(Index : int) -> void:
	current_dragged_item_data = {"Item" : inventory_data.item_data[Index], "Index" : Index}
	var new_drag_item : TextureRect = TextureRect.new()
	new_drag_item.texture = inventory_data.item_data[Index].item_texture
	new_drag_item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	new_drag_item.name = "ItemDrag"
	add_child(new_drag_item)
	
