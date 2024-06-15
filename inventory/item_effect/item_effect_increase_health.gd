class_name ItemEffectIncreaseHealth
extends ItemEffect


# An item effect that just heals a unit for an amount of health.


@export var amount: float = 1


func execute(item_data: ItemData, unit: Object) -> void:
	#unit.heal_damage(amount)
	print("Healed " + str(amount) + " health!")
	pass


func unexecute(item_data: ItemData, unit: Object) -> void:
	pass

