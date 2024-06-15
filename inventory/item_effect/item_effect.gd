class_name ItemEffect
extends Resource


# An item effect can be just about anything. Think of these as verbs.


# What should happen when effect executes.
func execute(item_data: ItemData, unit: Object) -> void:
	#print('item effect execute')
	pass


# What to do if effect finishes. Not needed most of the time but can come in handy.
func unexecute(item_data: ItemData, unit: Object) -> void:
	#print('item effect unexecute')
	pass
