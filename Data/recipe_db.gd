extends Node


const RECIPE = {
	"wooden_workbench":{
		"ingredients" : [
			{"item" : "wood_log", "amount" : 4}
		],
		"station" : ""
	},
	"stone_sword":{
		"ingredients" : [
			{"item" : "wood_log", "amount" : 1},
			{"item" : "stone", "amount" : 3}
		],
		"station" : "wooden_workbench"
	},
	
	"stone_axe":{
		"ingredients" : [
			{"item" : "wood_log", "amount" : 2},
			{"item" : "stone", "amount" : 3}
		],
		"station" : "wooden_workbench"
	},
	
	"stone_pickaxe":{
		"ingredients" : [
			{"item" : "wood_log", "amount" : 3},
			{"item" : "stone", "amount" : 3}
		],
		"station" : "wooden_workbench"
	},
}
