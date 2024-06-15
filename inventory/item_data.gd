class_name ItemData
extends Resource


@export var id: String = "new_item"
@export var name: String = "New Item"
@export_multiline var description: String = "My new item."
@export var icon: Texture = null
@export var max_stack_size: int = 1

# Change Object to Unit or Character or Entity or whatever
#func use(unit: Object) -> bool:
	#return true

func is_stackable() -> bool:
	return max_stack_size > 1


func on_enter_inventory() -> void:
	pass
	
	
func on_exit_inventory() -> void:
	pass
