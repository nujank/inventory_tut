class_name ItemSlotUI
extends TextureButton


# This is the visual counterpart to ItemSlot


signal hovered(index: int)
signal clicked(index: int)


@onready var initial_color: Color = $ColorRect.color


@onready var item_icon: TextureRect = $MarginContainer/ItemIcon
@onready var stack_count_label: RichTextLabel = $StackCountLabel


func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	
	pressed.connect(on_pressed)


# When we assign this item slot ui an item slot we really just need to make some stuff visible,
# And make sure the icon and label info is correct.
func set_item_slot(item_slot: ItemSlot) -> void:
	item_icon.visible = true
	stack_count_label.visible = true
	
	if item_slot == null:
		item_icon.visible = false
		stack_count_label.visible = false		
		return
		
	set_item_icon(item_slot.item_data.icon)
	set_stack_count_label(item_slot.stack_count)
	
	
func set_item_icon(icon: Texture2D) -> void:
	item_icon.texture = icon
	
	
func set_stack_count_label(count: int) -> void:
	stack_count_label.text = "[right]" + str(count) + "[/right]"


# when mouse enters we grab focused and emit that the this slot is being hovered.
# InventoryUI listens for hovered and clicked signals from this script and then just
# emits it's own respective signals.
func on_mouse_entered() -> void:
	hovered.emit(get_index())
	grab_focus()
	
	
func on_mouse_exited() -> void:
	release_focus()


# When we hover over this slot ui make the color rect gray
func on_focus_entered() -> void:
	$ColorRect.color = Color.GRAY
	
	
# Reset color rect to initial color when lost focus.
func on_focus_exited() -> void:
	$ColorRect.color = initial_color
	
	
# When we click on the slot ui emit clicks. InventoryUI listens for this signal and then emits it's
# own respective signal.
func on_pressed() -> void:
	clicked.emit(get_index())
