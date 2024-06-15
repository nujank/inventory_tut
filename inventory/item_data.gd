class_name ItemData
extends Resource


# ItemData is what it says on the tin. Data that consitutes an item.
# This being a Resource means we can create new ItemData resource instances in
# the file system. (Check "res://assets/items")

# This should contain all STATIC data that is common between all items. This is a definition.


# id is the internal string id of the item. Eventually you could have a ItemDatabase
# global that loads all item resources from asset/items and stores them in a dictionary
# with the key being the id
@export var id: String = "new_item"
# 
@export var name: String = "New Item"
@export_multiline var description: String = "My new item."
@export var icon: Texture = null
@export var max_stack_size: int = 1


func is_stackable() -> bool:
	return max_stack_size > 1
