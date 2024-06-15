class_name ItemEffectDebugPrint
extends ItemEffect


@export var message: String


func execute(item_data: ItemData, unit: Object) -> void:
	#print('item effect execute')
	print(message)
	pass


func unexecute(item_data: ItemData, unit: Object) -> void:
	#print('item effect unexecute')
	pass

