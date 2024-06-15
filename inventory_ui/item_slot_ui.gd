class_name ItemSlotUI
extends TextureButton


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
	
	
#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed == true:
			#clicked.emit()


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


func on_mouse_entered() -> void:
	hovered.emit(get_index())
	grab_focus()
	
	
func on_mouse_exited() -> void:
	release_focus()


func on_focus_entered() -> void:
	$ColorRect.color = Color.GRAY
	
	
func on_focus_exited() -> void:
	$ColorRect.color = initial_color
	
	
func on_pressed() -> void:
	clicked.emit(get_index())
