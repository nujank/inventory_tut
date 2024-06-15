class_name ItemSlot
extends Resource


signal stack_count_changed(count: int)


@export var item_data: ItemData
@export var stack_count: int = 1


func _init(item_data: ItemData, stack_count: int = 1) -> void:
	set_item_data(item_data)
	set_stack_count(stack_count)
	
	
func set_item_data(item_data: ItemData) -> void:
	self.item_data = item_data
	
	
func increase_stack_count(amount: int) -> int:
	var sum: int = stack_count + amount
	if sum > item_data.max_stack_size:
		var remainder: int = sum - item_data.max_stack_size
		set_stack_count(item_data.max_stack_size)
		return remainder
		
	set_stack_count(sum)
	return 0
	
	
func decrease_stack_count(amount: int) -> int:
	var sum: int = stack_count - amount
	if sum <= 0:
		var remainder: int = abs(sum)
		set_stack_count(0)
		return remainder
		
	set_stack_count(sum)
	return 0


func set_stack_count(amount: int) -> void:
	stack_count = clampi(amount, 0, item_data.max_stack_size)
	stack_count_changed.emit(stack_count)
	
	
func is_stack_full() -> bool:
	return stack_count >= item_data.max_stack_size
	
	
func is_stack_empty() -> bool:
	return stack_count <= 0
	
	
func is_stackable() -> bool:
	return item_data.is_stackable()
