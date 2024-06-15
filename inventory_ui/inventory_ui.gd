class_name InventoryUI
extends PanelContainer


signal item_slot_clicked(index: int)
signal item_slot_hovered(index: int)


@export var item_slot_ui_packed: PackedScene

var inventory: ItemInventory  = null

@onready var slot_container: GridContainer = $MarginContainer/GridContainer


func _ready() -> void:
	pass


func setup(inventory: ItemInventory) -> void:
	self.inventory = inventory
	
	populate_slot_grid(inventory)
	
	inventory.item_slot_added.connect(on_player_inventory_item_slot_added)
	inventory.item_slot_removed.connect(on_player_inventory_item_slot_removed)
	inventory.item_slot_stack_count_changed.connect(on_player_inventory_item_slot_stack_count_changed)


func populate_slot_grid(inventory: ItemInventory) -> void:
	for child in slot_container.get_children():
		child.queue_free()
		
	for item_slot in inventory.slots:			
		var slot_ui_inst: ItemSlotUI = item_slot_ui_packed.instantiate()
		slot_container.add_child(slot_ui_inst)
		slot_ui_inst.set_item_slot(item_slot)
		
		slot_ui_inst.hovered.connect(on_slot_ui_hovered)
		slot_ui_inst.clicked.connect(on_slot_ui_clicked)
		
		
func get_slot_ui(index: int) -> ItemSlotUI:
	if index >= slot_container.get_child_count(): return null
	
	return slot_container.get_child(index)
	
	
func disable() -> void:
	for slot in slot_container.get_children():
		if slot is ItemSlotUI:
			slot.disabled = true
			slot.focus_mode = Control.FOCUS_NONE
			
			
func enabled() -> void:
	for slot in slot_container.get_children():
		if slot is ItemSlotUI:
			slot.disabled = false
			slot.focus_mode = Control.FOCUS_ALL


func on_slot_ui_hovered(index: int) -> void:
	item_slot_hovered.emit(index)


func on_slot_ui_clicked(index: int) -> void:
	item_slot_clicked.emit(index)
	
	
func on_player_inventory_item_slot_added(index: int, item_slot: ItemSlot) -> void:
	var slot_ui: ItemSlotUI = get_slot_ui(index)
	if slot_ui == null: return
	
	slot_ui.set_item_slot(item_slot)


func on_player_inventory_item_slot_removed(index: int) -> void:
	var slot_ui: ItemSlotUI = get_slot_ui(index)
	if slot_ui == null: return
	
	slot_ui.set_item_slot(null)
	
	
func on_player_inventory_item_slot_stack_count_changed(index: int, count: int) -> void:
	var slot_ui: ItemSlotUI = get_slot_ui(index)
	if slot_ui == null: return
	
	slot_ui.set_stack_count_label(count)
