extends Node

const TOOLS_PATH = "res://Texture/Icons/Tools/"
const FOOD_PATH = "res://Texture/Icons/Food/"
const MATERIAL = "res://Texture/Icons/Materials/"

const ITEMS = {
	"wood_log":{
		"type" : "material",
		"catagory" : "log",
		"icon_name" : "log",
		"display_name" : "Wooden Log",
		"stack_size" : 16,
	},
	"stone":{
		"type" : "material",
		"catagory" : "stone",
		"icon_name" : "stone",
		"display_name" : "Stone",
		"stack_size" : 16,
	},
	"cooked_beef":{
		"type" : "food",
		"catagory" : "meat",
		"icon_name" : "95_steak",
		"display_name" : "Wooden Pickaxe",
		"energy" : 5,
		"stack_size" : 16,
	},
	
	"wooden_pickaxe": {
		"type" : "tools",
		"catagory" : "pickaxe",
		"icon_name" : "wooden_pickaxe",
		"display_name" : "Wooden Pickaxe",
		"item_attack" : 1.5,
		"item_speed" : 1,
		"mining_speed" : 1,
		"stack_size" : 1,
	},
	
	"wooden_sword": {
		"type" : "tools",
		"catagory" : "sword",
		"icon_name" : "wooden_sword",
		"display_name" : "Wooden Sword",
		"item_attack" : 2.5,
		"item_speed" : 1,
		"stack_size" : 1,
	},
	
	"wooden_axe": {
		"type" : "tools",
		"catagory" : "axe",
		"icon_name" : "wooden_axe",
		"display_name" : "Wooden Axe",
		"item_attack" : 3.5,
		"item_speed" : 1.5,
		"chopping_speed" : 1,
		"stack_size" : 1,
	},
	"stone_pickaxe": {
		"type" : "tools",
		"catagory" : "pickaxe",
		"icon_name" : "stone_pickaxe",
		"display_name" : "Stone Pickaxe",
		"item_attack" : 1.5,
		"item_speed" : 1,
		"mining_speed" : 1,
		"stack_size" : 1,
	},
	
	"stone_sword": {
		"type" : "tools",
		"catagory" : "sword",
		"icon_name" : "stone_sword",
		"display_name" : "Stone Sword",
		"item_attack" : 2.5,
		"item_speed" : 1,
		"stack_size" : 1,
	},
	
	"stone_axe": {
		"type" : "tools",
		"catagory" : "axe",
		"icon_name" : "stone_axe",
		"display_name" : "Stone Axe",
		"item_attack" : 5,
		"item_speed" : 1.3,
		"chopping_speed" : 1,
		"stack_size" : 1,
	},
	"wooden_workbench": {
		"type" : "placeable",
		"catagory" : "station",
		"icon_name" : "wooden_workbench",
		"display_name" : "WorkBench",
		"stack_size" : 1,
		
	}
}
