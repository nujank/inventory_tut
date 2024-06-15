class_name ItemEffectDebugPrint
extends ItemEffect


# A simple ItemEffect that just prints a debug message.


@export var message: String


func execute(item_data: ItemData, unit: Object) -> void:
	#print('item effect execute')
	print(message)
	pass


func unexecute(item_data: ItemData, unit: Object) -> void:
	#print('item effect unexecute')
	pass

