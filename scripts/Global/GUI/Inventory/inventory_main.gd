extends Control
@onready var inv_grid = get_node("GridContainer")

var items_to_load =[
	"res://scenes/GUI/Inventory/ItemResources/default_sword.tres",
	"res://scenes/GUI/Inventory/ItemResources/iron_shield.tres"
]

func _ready():
	for i in range(24):
		var slot = InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32,32))
		get_node("GridContainer").add_child(slot)
	for i in range (items_to_load.size()):
		var item = InventoryItem.new()
		item.init(load(items_to_load[i]))
		inv_grid.get_child(i).add_child(item)

func _on_control_gui_input(event):
	pass # Replace with function body.
