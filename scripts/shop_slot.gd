extends Control
class_name ShopSlot

#ik that making diffrent pixels sizes is bad for the game look but i didnt wanted the text to be so big :/

@onready var txt_rect = $TextureRect
@onready var cost_label = $TextureRect/cost
@onready var press = $TextureRect/button_anim
@onready var desc_icon = $TextureRect/desc_tab/desc_icon
@onready var desc_label = $TextureRect/desc_tab/description
@onready var desc_tab = $TextureRect/desc_tab



#loads the upgrades textures
var hp_upgrade_txt = preload("res://assets/upgrades/icons/hp_uprade.png")
var atk_upgrade_txt = preload("res://assets/upgrades/icons/atk_uprade.png")
var heal_txt = preload("res://assets/upgrades/icons/heal.png")
var speed_upgrade_txt = preload("res://assets/upgrades/icons/speed_upgrade.png")
var firerate_upgrade_txt = preload("res://assets/upgrades/icons/firerate_upgrade.png")
var reload_upgrade_txt = preload("res://assets/upgrades/icons/reload_upgrade.png")

#load the upgrades banners
var heal_banner_txt = preload("res://assets/upgrades/banners/heal_banner.png")
var atk_banner_txt = preload("res://assets/upgrades/banners/atk_banner.png")
var hp_banner_txt = preload("res://assets/upgrades/banners/hp_banner.png")
var speed_banner_txt = preload("res://assets/upgrades/banners/speed_banner.png")
var reload_banner_txt = preload("res://assets/upgrades/banners/reload_banner.png")
var firerate_banner_txt = preload("res://assets/upgrades/banners/firerate_banner.png")

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
		elif upgrade_on_slot == "firerate upgrade" and player.firerate > 0.06:#checks if the firerate isnt too low
			buy()
		elif upgrade_on_slot == "reload upgrade" and player.reload_speed > 0.07:#checks if the reload speed isn too low
			buy()
		elif upgrade_on_slot != "Heal" and upgrade_on_slot != "firerate upgrade" and upgrade_on_slot != "reload upgrade":
			buy()

func set_upgrade(upgrade): #sets the upgrade texture and the cost
	cost = Global.upgrades[upgrade]["cost"]
	cost_label.text = "Cost: " + str(cost)
	desc_label.text = Global.upgrades[upgrade]["desc"]
	if upgrade == "HP upgrade":
		txt_rect.texture = hp_upgrade_txt
		desc_icon.texture = hp_banner_txt
	elif upgrade == "Atk upgrade":
		txt_rect.texture = atk_upgrade_txt
		desc_icon.texture = atk_banner_txt
	elif upgrade == "Heal":
		txt_rect.texture = heal_txt
		desc_icon.texture = heal_banner_txt
	elif upgrade == "speed upgrade":
		txt_rect.texture = speed_upgrade_txt
		desc_icon.texture = speed_banner_txt
	elif upgrade == "firerate upgrade":
		txt_rect.texture = firerate_upgrade_txt
		desc_icon.texture = firerate_banner_txt
	elif upgrade == "reload upgrade":
		txt_rect.texture = reload_upgrade_txt
		desc_icon.texture = reload_banner_txt

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
			if player.firerate < 0.14:
				Global.upgrades.erase("firerate upgrade")
		elif upgrade_on_slot == "reload upgrade":
			player.reload_speed += Global.upgrades["reload upgrade"]["value"]
			if player.reload_speed < 0.2:
				Global.upgrades.erase("reload upgrade")
		add_child(empty_slot.instantiate()) #adds empty slot to hbox container
		txt_rect.queue_free() #deletes the slot

func _on_buy_zone_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		press.visible = true
		desc_tab.visible = true
		in_zone = true


func _on_buy_zone_body_exited(body):
	if body.is_in_group("player"):
		press.visible = false
		desc_tab.visible = false
		in_zone = false
