class_name GameManager

extends Node

@onready var player: Player = %Player
@onready var game_ui: MainGameUI = %GameUI

var level_folder = "res://scenes/levels/tower_spawn_pool" # directory of all spawnable levels
var enemy_folder = "res://scenes/enemies" # directory of all spawnable enemies
var main_menu_path = "res://scenes/main_menu.tscn" # scene that should be loaded when the player is sent to the main menu
var enemy_spawn_atlas_coords = Vector2i(9,0) #location in the tilesheet that coorisponds to the player spawn tile
var player_spawn_atlas_coords = Vector2i(9,1) #location in the tilesheet that coorisponds to the enemy spawn tile
var current_floor: int = 1
var enemies_left = 0

var current_level: Level



func _ready():
	# swap if you need to use the debug lvl
	# generate_level("res://scenes/levels/level_debug.tscn")
	generate_random_level()
	game_ui.fade_in()


#goes thorugh transition sequence and loads next floor
func go_to_next_floor():
	generate_random_level()
	current_floor += 1


func go_to_main_menu():
	get_tree().change_scene_to_file(main_menu_path)


#generates an array of strings containing paths to all levels in the level pool
func get_level_files() -> Array[String]:
	var levels: Array[String]

	var dir := DirAccess.open(level_folder)
	if dir == null: printerr("Could not open level directory"); return []
	for file: String in dir.get_files():
		levels.append(level_folder+"/"+file)
	return levels


#generates an array of strings containing paths to all enemies in the enemy pool
func get_enemy_files() -> Array[String]:
	var enemies: Array[String]

	var dir := DirAccess.open(enemy_folder)
	if dir == null: printerr("Could not open level directory"); return []
	for file: String in dir.get_files():
		enemies.append(enemy_folder+"/"+file)
	return enemies


#waits until a file is ready to be opened
func wait_for_file(file_path: String, max_wait_time: float = 5.0) -> bool:
	var time_elapsed = 0.0
	
	# loop until the file exists
	while !FileAccess.file_exists(file_path):
		# pause until the next frame processing step
		await get_tree().process_frame
		
		# track time to prevent an infinite loop if the file never arrives
		time_elapsed += get_process_delta_time()
		if time_elapsed >= max_wait_time:
			printerr("file " + file_path + " timed out.")
			return false
	return true


#generates and prepares the level of the given file path
func generate_level(level_path: String):
	if current_level:
		current_level.queue_free()
		clear_all_enemies()
	
	print("beginning generating level " + level_path + "...")

	await wait_for_file(level_path)
	
	#instance level layout
	var packed_level: PackedScene = load(level_path)
	var instanced_level: Node2D = packed_level.instantiate()
	get_tree().root.get_child(0).add_child.call_deferred(instanced_level)
	
	current_level = instanced_level
	
	await current_level.ready
	
	move_player_to_spawn()
	spawn_level_enemies()
	
	print("level generated!")


#spawns the enemy of the given file path at the given position
func spawn_enemy(enemy_path: String, position: Vector2):
	await wait_for_file(enemy_path)
	
	var packed_enemy: PackedScene = load(enemy_path)
	var instanced_enemy: Node2D = packed_enemy.instantiate()
	get_tree().root.get_child(0).add_child.call_deferred(instanced_enemy)
	
	instanced_enemy.position = position
	enemies_left += 1
	print(enemies_left)


#deletes every enemy currently in the level
#enemies MUST be in the group "enemy"
func clear_all_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()


#gives the file path of a random level out of the level pool
func get_random_level() -> String:
	var levels = get_level_files()
	var level = levels[randi_range(0,len(levels)-1)]
	return level


#gives the file path of a random enemy out of the enemy pool
func get_random_enemy() -> String:
	var enemies = get_enemy_files()
	var enemy = enemies[randi_range(0,len(enemies)-1)]
	return enemy


#gives the position of every tile in the tile map of the given atlas coordinates. 
#will delete all found tiles if "delete_tiles" is not set to false.
func get_all_grid_positions_of_tile(atlas_coords: Vector2i, delete_tiles: bool = false):
	var tile_map = current_level.tile_map_layer
	var grid_positions = tile_map.get_used_cells_by_id(-1, atlas_coords)
	
	#convert from grid position to global position
	var global_positions: Array[Vector2]
	for postion in grid_positions:
		global_positions.append(tile_map.to_global(tile_map.map_to_local(postion)))
		if delete_tiles:
			tile_map.erase_cell(postion)
	
	return global_positions


#spawns a random enemy on every enemy spawn tile
func spawn_level_enemies():
	var enemy_positions = get_all_grid_positions_of_tile(enemy_spawn_atlas_coords, true)
	for position in enemy_positions:
		spawn_enemy(get_random_enemy(), position)


#moves the player to the player spawn tile
func move_player_to_spawn():
	if get_all_grid_positions_of_tile(player_spawn_atlas_coords).get(0):
		player.position = get_all_grid_positions_of_tile(player_spawn_atlas_coords, true)[0]
	else:
		printerr("level has no player spawns!")


#picks a random level, then generates it
func generate_random_level():
	generate_level(get_random_level())

func on_enemy_death():
	enemies_left -= 1
	print(enemies_left)
