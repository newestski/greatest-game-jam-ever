extends Control
class_name ShopSlot

#ik that making diffrent pixels sizes is bad for the game look but i didnt wanted the text to be so big :/

@onready var txt_rect = $TextureRect
@onready var cost_label = $TextureRect/cost
@onready var press = $TextureRect/button_anim


#loads the upgrades textures
var hp_upgrade_txt = preload("res://assets/upgrades/hp_uprade.png")
var atk_upgrade_txt = preload("res://assets/upgrades/atk_uprade.png")
var heal_txt = preload("res://assets/upgrades/heal.png")
var speed_upgrade_txt = preload("res://assets/upgrades/speed_upgrade.png")
var firerate_upgrade_txt = preload("res://assets/upgrades/firerate_upgrade.png")

#empty slot so the hboxcontainer dont get screwd
var empty_slot = preload("res://scenes/empty_slot.tscn")

var cost: int = 0
var in_zone: bool = false
var player: Node2D
var health_component: Node
var team: String

var avaiable_upgrades = Global.upgrades.keys() #gets the upgrade dictionary
var upgrade_on_slot = avaiable_upgrades.pick_random() #picks a random upgrade

func _ready():
	print(upgrade_on_slot)
	set_upgrade(upgrade_on_slot)
	player = get_tree().get_first_node_in_group("player")
	health_component = player.get_node("HealthComponent")

func _input(event): #checks if someone tries to buy the upgrade
	if Input.is_action_just_pressed("interact") and in_zone == true:
		if upgrade_on_slot == "Heal" and health_component.health < health_component.max_health: #checks if the player has less that full hp to heal
			buy()
		elif upgrade_on_slot != "Heal":
			buy()

func set_upgrade(upgrade): #sets the upgrade texture and the cost
	cost = Global.upgrades[upgrade]["cost"]
	cost_label.text = "Cost: " + str(cost)
	if upgrade == "HP upgrade":
		txt_rect.texture = hp_upgrade_txt
	elif upgrade == "Atk upgrade":
		txt_rect.texture = atk_upgrade_txt
	elif upgrade == "Heal":
		txt_rect.texture = heal_txt
	elif upgrade == "speed upgrade":
		txt_rect.texture = speed_upgrade_txt
	elif upgrade == "firerate upgrade":
		txt_rect.texture = firerate_upgrade_txt

func buy(): #deletes the money and apllies the buff
	if Global.money >= cost:
		Global.money -= cost
		var hit_health_component: HealthComponent = player.get_node("HealthComponent")
		if upgrade_on_slot == "HP upgrade":
			hit_health_component.health_upgrade(Global.upgrades["HP upgrade"]["value"])
		elif upgrade_on_slot == "Atk upgrade":
			player.atk_upgrade(Global.upgrades["Atk upgrade"]["value"])
		elif upgrade_on_slot == "Heal":
			hit_health_component.heal(Global.upgrades["Heal"]["value"])
		elif upgrade_on_slot == "speed upgrade":
			player.walk_speed += Global.upgrades["speed upgrade"]["value"]
		elif upgrade_on_slot == "firerate upgrade":
			player.firerate += Global.upgrades["firerate upgrade"]["value"]
		add_child(empty_slot.instantiate()) #adds empty slot to hbox container
		txt_rect.queue_free() #deletes the slot

func _on_buy_zone_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		print("gracz w strefie")
		press.visible = true
		in_zone = true


func _on_buy_zone_body_exited(body):
	if body.is_in_group("player"):
		press.visible = false
		in_zone = false
