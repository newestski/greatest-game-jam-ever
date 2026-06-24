extends Node

var money = 0 #player money

#dictionary of upgrades
var upgrades = {
	"Atk upgrade": {"cost": 80, "value": 10},
	"HP upgrade": {"cost": 60, "value": 15},
	"Heal": {"cost": 50, "value": 40},
	"speed upgrade": {"cost": 90, "value": 15},
	"firerate upgrade": {"cost": 60, "value": -0.05},
}

#dictionary of when enemies are introduced
var enemies = {
	"res://scenes/enemies/spinny_orb.tscn": {"first_floor": 1},
	"res://scenes/enemies/disc_thrower.tscn": {"first_floor": 3},
	"res://scenes/enemies/spinning_rammer.tscn": {"first_floor": 5}
}
