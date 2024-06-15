class_name Main
extends Node3D


# NOTE: Code is not final. Some methods are not used but are there to give an idea of
# what can be done when more fleshed out.

# Core scripts at a glance:

	# DATA/LOGIC SIDE
	# ItemInventory - The core inventory script. Main responsibility is managing a collection of ItemSlot's
	# ItemSlot - Represents a single stack of ItemData's
	# ItemData - The base item data resource.
		# ItemDataWeapon - Base weapon item data.
		# ItemDataConsumable - Base consumable item data.
	# ItemEffect - An object that represents some behavior that can be executed when items are used.
		# ItemEffectDebugPrint
		# ItemEffectIncreaseHealth
		
	# VISUAL SIDE
	# InventoryUI - Responsible for the display of an ItemInventory. Manages a collection of ItemSlotUI's
	# ItemSlotUI - Responsible for the display of an ItemSlot.
	# ItemInfoPanel - A simple example tool tip node.
	
	
# To create a new item create a new ItemData, ItemDataConsumbale or ItemDataWeapon resource inside
# "res://assets/items/". You can then add it below like void_sword_res for now.
# Eventually you'll want an ItemDatabase for this. (See ItemData)
# Selecting the new resource will let you change it's data in inspector. Note On Used Effect for next part.

# To create a new ItemEffect create a new script inside "res://inventory/item_effect"
# Give it an appropriate class name, like "ItemEffectTeleportRandom".
# Make sure it extends from ItemEffectConsumbale as only Consumables have an On Use Effect.
# Inside execute() you'll put whatever logic you'll need to teleport the unit/entity.
# To give an item the effect, open it's resource in inspector and click On Used Effect drop down then
# "New ItemEffectTeleportRandom". Expanding it will then let you assign any values exported from the
# item effect script.
# You could also give ItemDataWeapon or ItemDataArmor an "on_equipped_effect". It would act just
# like on_use_effect does in Consumable. The possibilities are endless!


# Things yet to be included:
	# Item pickups. Essentially you'll just create an ItemPickup scene. Make it an area and then in
			# it's script give it a variable to hold the ItemData that the ItemPickup represents.
			# When interacting with the ItemPickup just grab the ItemData property from it and add
			# it to inventory before freeing the ItemPickup node.
	# Hotbar. Hotbar is basically the exact same as the normal inventory.
			# Create a new hotbar_inventory: ItemInventory
			# Create a new InventoryUI in Main scene, call it HotbarInventoryUI.
			# Boom, you can add/remove items to hotbar just like inventory.
			# Then to move items between them is as simple as removing item from main inventory and
			# adding it to hotbar or vice-versa.
	# AND MANY MORE! But I am le tired.


# This ItemInventory class can be used for both main inventory, hotbar or storage.
# Also this probably wouldnt belong in the main scene or game scene. You'd probably want
# your Player to contain the inventory.
var inventory: ItemInventory
# For example like this.
#var hotbar_inventory: ItemInventory

# Right now I'm just putting these here for simplicity. But ideally you would have a
# database of ItemData's
@export var void_sword_res: ItemData
@export var health_potion_res: ItemData

# The InventoryUI just renders the state of the Inventory, the items it contains.
@onready var inventory_ui: InventoryUI = $InventoryUI
# So for a hotbar you'd need another scene
#@onready var hotbar_inventory_ui: InventoryUI = $HotbarInventoryUI

# Just a tooltip
@onready var item_info_panel: ItemInfoPanel = $ItemInfoPanel

# Since in this example there is no real Entity I'm using Object as a placeholder.
# Anywhere I'm passing in an argument of type Object in this code replace it with your Unit/Entity/Whatever.
var player: Object = null


func _ready() -> void:
	# We create a new inventory
	inventory = ItemInventory.new()
	# Add some items to it
	inventory.add_items(void_sword_res, 1)
	inventory.add_items(health_potion_res, 5)
	
	# We have to setup inventory_ui to assign it an inventory to represent
	inventory_ui.setup(inventory)
	
	# Then we can listen for some signals from the inventory ui
	inventory_ui.item_slot_clicked.connect(on_inventory_item_slot_clicked)
	inventory_ui.item_slot_hovered.connect(on_inventory_item_slot_hovered)
	
	# To setup the hotbar stuff you'd do something like..
	# hotbar_inventory = ItemInventory.new()
	# hotbar_inventory.inventory_size = 5
	# hotbar_inventory_ui.setup(hotbar_inventory)
	# hotbar_inventory_ui.item_slot_clicked.connect(on_hotbar_inventory_item_slot_clicked)
	# hotbar_inventory_ui.item_slot_hovered.connect(on_hotbar_inventory_item_slot_hovered)


# Basically all this is doing is saying:
# "When we click on an inventory slot ui we want to use that item and remove it from the inventory."
# You might instead want to instantiate a new ContextMenu scene so you can select what action to
# perform on an item.
func on_inventory_item_slot_clicked(index: int) -> void:
	# We get the item at the index from the inventory
	var item_data: ItemData = inventory_ui.inventory.get_item_at(index)
	# If we did have an item at that index
	if item_data != null:
		print(item_data.name)
		# And that item is a consumable
		if item_data is ItemDataConsumable:
			# Use the item
			if item_data.use(player) == true:
				# And remove it from inventory
				inventory_ui.inventory.remove_items_at(index)
	
	
# Basically, if we hover the mouse over an item slot ui then set the tooltip to display
# the items data
func on_inventory_item_slot_hovered(index: int) -> void:
	# We get the item at the index from the inventory
	var item_data: ItemData = inventory_ui.inventory.get_item_at(index)
	# If we dont have an item at the index. (i.e. We are hovering over an item slot ui that has no item)
	if item_data == null:
		# Tell tooltip to clear it's display
		item_info_panel.set_item_data(null)
		return
		
	# Otherwise we have an item so we assign the tooltip the item_data
	item_info_panel.set_item_data(item_data)
