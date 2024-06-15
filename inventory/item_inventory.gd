class_name ItemInventory
extends Resource


signal item_slot_added(index: int, item_slot: ItemSlot)
signal item_slot_removed(index: int)
signal item_slot_stack_count_changed(index: int)


@export var inventory_size: int = 30
@export var slots: Array[ItemSlot] = []


func _init() -> void:
	for i in inventory_size:
		slots.push_back(null)
	

# this doesn't belong here. Probably belongs on either the Player
# or the inventory ui interface. (Or maybe a different one idfk)
#func use_item(index: int, unit: Unit) -> bool:
	#return true
	#
	#
#func discard_item(index: int, unit: Unit) -> bool:
	#return true
	

func add_items(item_data: ItemData, count: int = 1) -> int:
	var stack_count_left: int = count
	for i in slots.size():
		var slot: ItemSlot = get_slot_at(i)
		if slot == null:
			continue
			
		if slot.item_data.id == item_data.id && slot.is_stack_full() == false:
			stack_count_left = slot.increase_stack_count(stack_count_left)
			
	if stack_count_left > 0:
		for i in slots.size():
			var slot: ItemSlot = get_slot_at(i)
			if slot == null:
				var count_to_add: int = min(item_data.max_stack_size, stack_count_left)
				add_slot_at(i, ItemSlot.new(item_data, count_to_add))
				stack_count_left -= count_to_add
				if stack_count_left <= 0:
					break
		
	return stack_count_left


# returns number of items that were not added
func add_items_at(index: int, item_data: ItemData, count: int = 1) -> int:
	var slot: ItemSlot = get_slot_at(index)
	if slot == null:
		var count_to_add: int = min(item_data.max_stack_size, count)
		add_slot_at(index, ItemSlot.new(item_data, count_to_add))
		count -= count_to_add
		return count
		
	if slot.item_data.id == item_data.id && slot.is_stack_full() == false:
		return slot.increase_stack_count(count)
		
	return count


# return number of items that were not removed
func remove_items_at(index: int, count: int = 1) -> int:
	var slot: ItemSlot = get_slot_at(index)
	
	if slot == null:
		return count
		
	if slot.is_stack_empty() == false:
		var remainder: int = slot.decrease_stack_count(count)
		if slot.is_stack_empty():
			slots[index] = null
		
		return remainder
		
	return count
	

func get_item_at(index: int) -> ItemData:
	var slot: ItemSlot = get_slot_at(index)
	
	if slot == null:
		return null
		
	return slot.item_data
	
	
# slots
func add_slot_at(index: int, item_slot: ItemSlot) -> bool:
	if get_slot_at(index) != null:
		return false
		
	item_slot.stack_count_changed.connect(func(count):
		on_item_slot_stack_count_changed(index, count)
	)
		
	slots[index] = item_slot
	
	item_slot_added.emit(index, item_slot)
	return true
	
	
func remove_slot_at(index: int) -> bool:
	if get_slot_at(index) == null:
		return false
		
	slots[index] = null
	
	item_slot_removed.emit(index)
	return true
	
	
func set_slot_at(index: int, item_slot: ItemSlot) -> void:
	slots[index] = item_slot
	
	
func get_slot_at(index: int) -> ItemSlot:
	return slots[index]
	
	
func swap_item_slots(slot_a: ItemSlot, slot_b: ItemSlot) -> bool:
	var item_data: ItemData = slot_a.item_data
	var stack_count: int = slot_a.stack_count
	
	slot_a.set_item_data(slot_b.item_data)
	slot_a.set_stack_count(slot_b.stack_count)
	
	slot_b.set_item_data(item_data)
	slot_b.set_stack_count(stack_count)
	return true
	
	
func attempt_move_stacks_into(slot_a: ItemSlot, slot_b: ItemSlot) -> bool:
	if slot_a == null || slot_b == null: return false
	if slot_a.item_data == null || slot_b.item_data == null: return false
	if slot_a.item_data.id != slot_b.item_data.id: return false
	
	if slot_b.is_stack_full() == true: return false
	if slot_b.is_stackable() == false: return false
	if slot_a.is_stack_empty() == true: return false	
		
	var remainder: int = slot_b.increase_stack_count(slot_a.stack_count)
	slot_a.set_stack_count(remainder)
		
	return true
	
	
#func are_item_slots_different(slots: Array[ItemSlot]) -> bool:
	#var last_item_slot_checked: ItemSlot = slots[0]
	#for i in range(1, slots.size()):			
		#if slots[i].item_data == last_item_slot_checked.item_data:
			#return false
			#
	#return true
	
	
func clear_item_slots() -> void:
	for i in inventory_size:
		remove_slot_at(i)
	
	
func debug_print() -> void:
	var ret: String = "["
	for slot in slots:
		if slot == null:
			ret += "none"
		else:
			ret += str(slot.item_data.id) + " x" + str(slot.stack_count)
		
		ret += ", "
	ret += "]"
	print(ret)


func on_item_slot_stack_count_changed(index: int, count: int) -> void:
	if count <= 0:
		remove_slot_at(index)
		return
		
	item_slot_stack_count_changed.emit(index, count)
