class_name ItemInfoPanel
extends VBoxContainer


# Simple little tooltip node that can be assigned an item_data to display info


@onready var selected_item_name_label: RichTextLabel = $HBoxContainer/SelectedItemNameLabel
@onready var selected_item_description_label: RichTextLabel = $SelectedItemDescriptionLabel
@onready var selected_item_icon: TextureRect = $HBoxContainer/SelectedItemIcon


func set_item_data(item_data: ItemData) -> void:
	if item_data == null:
		selected_item_name_label.text = ""
		selected_item_description_label.text = ""
		selected_item_icon.texture = null
		return
		
	selected_item_name_label.text = item_data.name
	selected_item_description_label.text = item_data.description
	selected_item_icon.texture = item_data.icon
