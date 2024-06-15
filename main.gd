class_name Main
extends Node3D


var inventory: ItemInventory
@export var void_sword_res: ItemData
@export var health_potion_res: ItemData

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var item_info_panel: ItemInfoPanel = $ItemInfoPanel


var player: Object = null

func _ready() -> void:
	inventory = ItemInventory.new()
	inventory.add_items(void_sword_res, 1)
	inventory.add_items(health_potion_res, 5)
	
	inventory_ui.setup(inventory)
	
	inventory_ui.item_slot_clicked.connect(on_inventory_item_slot_clicked)
	inventory_ui.item_slot_hovered.connect(on_inventory_item_slot_hovered)


func on_inventory_item_slot_clicked(index: int) -> void:
	var slot_ui: ItemSlotUI = get_viewport().gui_get_focus_owner()
	var slot_index: int = slot_ui.get_index()
	var item_data: ItemData = inventory_ui.inventory.get_item_at(slot_index)
	if item_data != null:
		print(item_data.name)
		if item_data is ItemDataConsumable:
			if item_data.use(player) == true:
				inventory_ui.inventory.remove_items_at(slot_index)
	
	
func on_inventory_item_slot_hovered(index: int) -> void:
	var item_data: ItemData = inventory_ui.inventory.get_item_at(index)
	if item_data == null:
		item_info_panel.set_item_data(null)
		return
		
	item_info_panel.set_item_data(item_data)
