class_name ItemData
extends Resource

enum Type{WEAPON, MISC, MAIN}

@export var type: Type
@export var item_name:String
@export var item_dmg:int
@export var item_def:int
@export var item_healing:int
@export var item_stackable:bool
@export var count:int
@export var item_texture:Texture2D
@export_multiline var desc:String
