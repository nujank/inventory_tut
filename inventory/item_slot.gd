class_name ItemSlot
extends Resource


# An ItemSlot is an object that represents a stack of ItemData's.


signal stack_count_changed(count: int)


# This is the item_data this slot represents.
@export var item_data: ItemData
# And this is the current number of that item_data we have in this slot.
@export var stack_count: int = 1


# When we instantiate a new slot we must give it an item_data to represent as well as a number of
# those items it contains.
# Note that we default the stack_count param to 1 so we don't have to include it when
# creating a slot with only 1 item.
func _init(item_data: ItemData, stack_count: int = 1) -> void:
	set_item_data(item_data)
	set_stack_count(stack_count)
	
	
func set_item_data(item_data: ItemData) -> void:
	self.item_data = item_data
	
	
# We want to increase the number of items in this slot, but if we attempt to add too many items
# we return the number of items we could not add to this slot.
func increase_stack_count(amount: int) -> int:
	# Calculate the total count of our current stack_count plus the amount we want to add.
	var sum: int = stack_count + amount
	# If we are attempting to add too many items
	if sum > item_data.max_stack_size:
		# We calculate the amount of items from "sum" that we can't add to the slot
		var remainder: int = sum - item_data.max_stack_size
		# We set the stack count to be a full stack
		set_stack_count(item_data.max_stack_size)
		# And return the number of items we couldnt add
		return remainder
		
	# If we did not attempt to add too many items then set the stack count to the number
	# of items we want to add
	set_stack_count(sum)
	
	# We were able to add all items so there were no items to return
	return 0
	
	
# In a similar way to increase_stack_count, we want to decrease the number of items in a slot
# but if we attempt to remove too many items we want to return the number of items we were not
# able to remove.
func decrease_stack_count(amount: int) -> int:
	var sum: int = stack_count - amount
	if sum <= 0:
		var remainder: int = abs(sum)
		set_stack_count(0)
		return remainder
		
	set_stack_count(sum)
	return 0


# Ideally by the time we call this method we should have done some
# checking to make sure we aren't setting the stack count to an invalid number.
# But just in case we clamp the amount between 0 and max_stack_size
func set_stack_count(amount: int) -> void:
	stack_count = clampi(amount, 0, item_data.max_stack_size)
	# When a slots stack count changes other things may want to know about it,
	# so we emit a signal to let them know.
	stack_count_changed.emit(stack_count)
	
# These functions should be straightforward hopefully
func is_stack_full() -> bool:
	return stack_count >= item_data.max_stack_size
	
	
func is_stack_empty() -> bool:
	return stack_count <= 0
	
	
func is_stackable() -> bool:
	return item_data.is_stackable()
