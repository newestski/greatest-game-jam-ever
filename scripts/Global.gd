extends Node

var money = 100 #player money

#dictionary of upgrades
var upgrades = {
	"Atk upgrade": {"cost": 80, "value": 10, "desc": "This scroll will allow you to deal more damage to these poor souls. [Raises your damage by 10]"},
	"HP upgrade": {"cost": 60, "value": 15, "desc": "This liquid will make your skin 2 times tougher to absorb more damage. [Adds 15 health points]"},
	"Heal": {"cost": 50, "value": 40, "desc": "This holy juice will heal your injuries in seconds!!!. [Heals 40 health points]"},
	"speed upgrade": {"cost": 90, "value": 15, "desc": "This enchanted feathers will allow you to run like a maniac around the battlefield! [Adds +15 speed]"},
	"firerate upgrade": {"cost": 60, "value": -0.05, "desc": "This revolver modification will make your gun fire alot faster. [Reduces the firerate cooldown by 0.05s]"},
	"reload upgrade": {"cost": 90, "value": -0.07, "desc": "This runes will allow you to reload the bullets alot faster now by enchanting your hands precision and speed! [reduces the reload speed between bullets by 0.07s]"}
}
