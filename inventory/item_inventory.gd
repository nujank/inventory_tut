class_name ItemInventory
extends Resource


# The ItemInventory class doesn't manage ItemData's directly.
# Instead it manages a collection of ItemSlots.


signal item_slot_added(index: int, item_slot: ItemSlot)
signal item_slot_removed(index: int)
signal item_slot_stack_count_changed(index: int)


# We declare the size of this inventory and define the slot array
@export var inventory_size: int = 30
@export var slots: Array[ItemSlot] = []


# When we instantiate a new inventory we want to create enough slots to fill the inventory
# but set them to null (empty)
func _init() -> void:
	for i in inventory_size:
		slots.push_back(null)
	

# When we add items we request the caller to provide the item_data and count of how many items to add.
# "count" can potentially be larger than the item_data's max_stack_count. So we have to do some extra
# logic to make sure if we pass in 20 items, but the item_data can only stack to 10, that we create
# extra item slots to contain the extra items.
func add_items(item_data: ItemData, count: int = 1) -> int:
	# So here we track how many items we still want to add to inventory.
	# At the start we just set it to the total count passed in
	var stack_count_left: int = count
	
	# First we wanna go through the inventory slots and find any slots that contain the same
	# type of item we are trying to add. If we find some, then we add items to it.
	# So for each slot in our inventory
	for i in slots.size():
		# We get the current slot
		var slot: ItemSlot = get_slot_at(i)
		# If that slot is empty we continue to the next slot
		if slot == null:
			continue
			
		# If we find a slot that is NOT full and contains the same type of item we are trying to add
		if slot.item_data.id == item_data.id && slot.is_stack_full() == false:
			# Increase stack count takes in a number of items to add and returns the number of items
			# That were NOT able to be added to the slot.
			# So here we are basically adding as many items to this slot as possible and
			# just updating the number of items we still need to add.
			stack_count_left = slot.increase_stack_count(stack_count_left)
			
			
	# If we've gone through the whole inventory and did not find any more slots that contain
	# the same type of item we are trying to add then we know we need to add a new slot
	# So if we still have items to add
	if stack_count_left > 0:
		# We go through all inventory slots
		for i in slots.size():
			# We get the current slot
			var slot: ItemSlot = get_slot_at(i)
			# Now if that slot IS empty
			if slot == null:
				# We determine the number of items to add to the slot. We can get the min
				# between the number of items we have left to add and the max_stack_size of the
				# item we're adding to make sure if we have more items than max_stack_size, we
				# still just add max_stack_size number of items to the slot
				var count_to_add: int = min(item_data.max_stack_size, stack_count_left)
				# Finally create a new ItemSlot, give it the item_data and count_to_add and assign it
				# to inventory slot position i
				add_slot_at(i, ItemSlot.new(item_data, count_to_add))
				# We subtract the number of items we just added to the slot from our remaining
				# stack count
				stack_count_left -= count_to_add
				# If we have no items left to add, break out. We're done!
				if stack_count_left <= 0:
					break
		
	# If we have filled up the inventory and have no more room we return the number of items we were not able to add
	return stack_count_left


# This isn't currently being used.
func add_items_at(index: int, item_data: ItemData, count: int = 1) -> int:
	var slot: ItemSlot = get_slot_at(index)
	if slot == null:
		var count_to_add: int = min(item_data.max_stack_size, count)
		add_slot_at(index, ItemSlot.new(item_data, count_to_add))
		count -= count_to_add
		return count
		
	if slot.item_data.id == item_data.id && slot.is_stack_full() == false:
		return slot.increase_stack_count(count)
		
	# We return the number of items that were not added to this slot
	return count


func remove_items_at(index: int, count: int = 1) -> int:
	# We get the slot at the index we pass in
	var slot: ItemSlot = get_slot_at(index)
	
	# If that slot is already empty, we can't remove items from this slot
	if slot == null:
		# So we return the number of items we were not able to remove, which is the same
		# number of items we passed in
		return count
		
	# If the slot is NOT empty though
	if slot.is_stack_empty() == false:
		# We try to remove count number of items from the slot
		# and decrease_stack_count() returns the number of items we were not able to remove
		# from the slot
		var remainder: int = slot.decrease_stack_count(count)
		# If the slot has no more items in it
		if slot.is_stack_empty():
			# Set the slot to be null.
			# We have to do this because is_stack_empty() just deals with stack_count
			# Meaning the slot still points to an item_data.
			# Nulling it makes it fully empty
			slots[index] = null
		
		# Return number of items that were not removed
		return remainder
		
	# return number of items that were not removed
	return count
	

# Self explanitory, I hope.
func get_item_at(index: int) -> ItemData:
	var slot: ItemSlot = get_slot_at(index)
	
	if slot == null:
		return null
		
	return slot.item_data
	
	
# SLOT MANAGEMENT
func add_slot_at(index: int, item_slot: ItemSlot) -> bool:
	# If we already have a slot at this index, bail
	if get_slot_at(index) != null:
		return false
		
	# We listen to the item_slot for when it count changes
	item_slot.stack_count_changed.connect(func(count):
		on_item_slot_stack_count_changed(index, count)
	)
		
	# We set the item_slot in the inventory at index
	slots[index] = item_slot
	
	# Then we signal out that a slot (item_slot) was added at index
	item_slot_added.emit(index, item_slot)
	return true
	
	
func remove_slot_at(index: int) -> bool:
	# If there is no slot to remove, bail
	if get_slot_at(index) == null:
		return false
		
	# Null out slot at index
	slots[index] = null
	
	# Signal out that a slot was removed at index
	item_slot_removed.emit(index)
	return true
	
	
func set_slot_at(index: int, item_slot: ItemSlot) -> void:
	slots[index] = item_slot
	
	
func get_slot_at(index: int) -> ItemSlot:
	return slots[index]
	
	
# Here we are just swapping item slots. Not used currently. But could be used for
# drag and drop swapping at some point.
func swap_item_slots(slot_a: ItemSlot, slot_b: ItemSlot) -> bool:
	var item_data: ItemData = slot_a.item_data
	var stack_count: int = slot_a.stack_count
	
	slot_a.set_item_data(slot_b.item_data)
	slot_a.set_stack_count(slot_b.stack_count)
	
	slot_b.set_item_data(item_data)
	slot_b.set_stack_count(stack_count)
	return true
	
	
# This is also not used. Just attempts to move as many items from one slot to another.
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
	
	
func clear_item_slots() -> void:
	for i in inventory_size:
		remove_slot_at(i)
	
	
# Debug prints the contents of the inventory. Not needed.
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


# When an item slot's stack count changes we want to remove the slot if it's empty of items.
# If it's not empty though we wanna signal out that the slot's stack count at index has changed
func on_item_slot_stack_count_changed(index: int, count: int) -> void:
	if count <= 0:
		remove_slot_at(index)
		return
		
	item_slot_stack_count_changed.emit(index, count)
