# Script to handle save and load functions
# Following this tutorial: https://youtu.be/R-rALRlgbe8?is=vqL5IG8YR2DzgIrE
# And expanding on it

extends Node

const SAVES_DIRECTORY: String = "saves"
const SLOT_DIRECTORY_NAME: String = "slot_"
const SAVE_NAME: String = "save.json"
const TEMP_SAVE_NAME: String = "save.tmp"

const CONFIG_DIRECTORY: String = "config"
const CONFIG_NAME: String = "config.json"
const TEMP_CONFIG_NAME: String = "config.tmp"

# Feed this a dictionary of data and a number for the slot to save in
func save_game(game_data: Dictionary, slot: int = 1) -> void:
	
	# Checking if the saves directory exists, and if not, creating it
	var file_path: String = str("user://",SAVES_DIRECTORY,"/",SLOT_DIRECTORY_NAME,slot,"/")
	check_directory(file_path)
	
	var temp_save_file: String = str(file_path, TEMP_SAVE_NAME)
	
	# Accessing the save file and writing to it
	print(str("Accessing temporary save file at: ", temp_save_file))
	var opened_file: FileAccess = FileAccess.open(temp_save_file, FileAccess.WRITE)
	if opened_file == null:
		push_error("Error opening file at ", temp_save_file, ", error: ", FileAccess.get_open_error())
		return
		
	game_data.sort()
	print(str("Converting this data to JSON: ", game_data))
	for key in game_data:
		match typeof(game_data[key]):
			TYPE_VECTOR2: game_data[key] = _vec2_to_dict(game_data[key])
			TYPE_VECTOR3: game_data[key] = _vec3_to_dict(game_data[key])
			TYPE_COLOR: game_data[key] = _color_to_dict(game_data[key])
			TYPE_INT: game_data[key] = _int_to_dict(game_data[key])
	var json_string = JSON.stringify(game_data)
	print(str("The converted data looks like this: ", json_string))
	opened_file.store_line(json_string)
	opened_file.close()
	
	var final_save_file: String = str(file_path, SAVE_NAME)
	
	# Replacing the .tmp file if everything went correctly at this stage
	DirAccess.rename_absolute(temp_save_file, final_save_file)

# Load the save from a slot, match it to a passed-in pre-existing structure
func load_save(game_data: Dictionary, slot: int = 1) -> void:
	
	# Checking if the saves directory exists, and if not, creating it
	var file_path: String = str("user://",SAVES_DIRECTORY,"/",SLOT_DIRECTORY_NAME,slot,"/")
	check_directory(file_path)
	
	var save_file: String = str(file_path, SAVE_NAME)
	if FileAccess.file_exists(save_file):
		
		# Opening save slot and grabbing saved string
		print("Now loading game data")
		var opened_file: FileAccess = FileAccess.open(save_file, FileAccess.READ)
		var string_data: String = opened_file.get_line()
		print(str("Loaded game data is: ", string_data))
		opened_file.close()
		
		# Parsing opened string as JSON
		var parsed_game_data: Dictionary = _parse_data(string_data)
			
		# Matching parsed data to pre-existing game data. This verifies the data and drops old keys
		for key in game_data:
			if parsed_game_data.has(key): game_data[key] = parsed_game_data[key]
		game_data.sort()
		print("Loaded data looks like this: ", game_data)

	else:
		print("No game data found. Keeping data as is.")

	
func save_config(config_data: Dictionary) -> void:
	
	var standalone_config_data: Dictionary = config_data.duplicate_deep()
	
	# Checking if the saves directory exists, and if not, creating it
	var file_path: String = str("user://",CONFIG_DIRECTORY,"/")
	check_directory(file_path)
	
	var temp_config_file: String = str(file_path, TEMP_CONFIG_NAME)
	
	# Accessing the config file and writing to it
	print(str("Accessing config file at: ", temp_config_file))
	var opened_file: FileAccess = FileAccess.open(temp_config_file, FileAccess.WRITE)
	if opened_file == null:
		push_error("Error opening file at ", temp_config_file, ", error: ", FileAccess.get_open_error())
		return
		
	standalone_config_data.sort()
	print(str("Converting this data to JSON: ", standalone_config_data))
	for key in standalone_config_data:
		match typeof(standalone_config_data[key]):
			TYPE_VECTOR2: standalone_config_data[key] = _vec2_to_dict(standalone_config_data[key])
			TYPE_VECTOR3: standalone_config_data[key] = _vec3_to_dict(standalone_config_data[key])
			TYPE_COLOR: standalone_config_data[key] = _color_to_dict(standalone_config_data[key])
			TYPE_INT: standalone_config_data[key] = _int_to_dict(standalone_config_data[key])
	var json_string = JSON.stringify(standalone_config_data)
	print(str("The converted data looks like this: ", json_string))
	opened_file.store_line(json_string)
	opened_file.close()
	
	var final_config_file: String = str(file_path, CONFIG_NAME)
	
	# Replacing the .tmp file if everything went correctly at this stage
	DirAccess.rename_absolute(temp_config_file, final_config_file)
	

func load_config(config_data: Dictionary) -> void:
	
	# Checking if the config directory exists, and if not, creating it
	var file_path: String = str("user://",CONFIG_DIRECTORY,"/")
	check_directory(file_path)
	
	var config_file: String = str(file_path, CONFIG_NAME)
	if FileAccess.file_exists(config_file):
		
		# Opening save slot and grabbing saved string
		print("Now loading config data")
		var opened_file: FileAccess = FileAccess.open(config_file, FileAccess.READ)
		var string_data: String = opened_file.get_line()
		print(str("Loaded config data is: ", string_data))
		opened_file.close()
		
		# Parsing opened string as JSON
		var parsed_config_data: Dictionary = _parse_data(string_data)
			
		# Matching parsed data to pre-existing game data. This verifies the data and drops old keys
		for key in config_data:
			if parsed_config_data.has(key): config_data[key] = parsed_config_data[key]
		config_data.sort()
		print("Loaded config data looks like this: ", config_data)

	else:
		print("No config data found. Keeping data as is.")
	
# Checking if the saves directory exists, and if not, creating it	
func check_directory(file_path: String):
	if DirAccess.dir_exists_absolute(file_path) == false:
		print(str("Saves directory doesn't exist yet, creating it at: ", file_path))
		DirAccess.make_dir_recursive_absolute(file_path)
	print(str("Accessing saves directory at: ", file_path))

# Export the save file of a slot using the native file picker for ease of transfer
func export_save(game_data: Dictionary, game_name: String = "", game_version: String = "", slot: int = 1) -> void:
	# Make sure to save the up-to-date data
	print("Starting to compile data for savegame export")
	save_game(game_data,slot)
	
	# Opening the newly saved file and pushing JavaScript for download
	var file_path: String = str("user://",SAVES_DIRECTORY,"/",SLOT_DIRECTORY_NAME,slot,"/")
	var save_file: String = str(file_path, SAVE_NAME)
	
	if FileAccess.file_exists(save_file):
		print("Save file has been opened for export")
		var opened_file: FileAccess = FileAccess.open(save_file, FileAccess.READ)
		var string_data: String = opened_file.get_line()
		opened_file.close()
		var file_to_save_name: String = str(game_name.replace(" ", "_"),"_",game_version,"_slot_",slot,"_",SAVE_NAME.replace(" ", "_")).to_lower()
		
		if OS.get_name() == 'Web': # Export save works only on web builds for now
			var buffer: PackedByteArray = string_data.to_utf8_buffer()
			JavaScriptBridge.download_buffer(buffer, file_to_save_name)
		else: push_error("Error trying to export save file: unsupported device")
		
	else: push_error("Couldn't export the save file, savegame doesn't exists")

# Prompts the user for a .json file, validates it, and imports it into the data passed in reference
# Using HTML5 File Dialog plugin
func import_save(game_data: Dictionary, slot: int = 1) -> void:
	if OS.get_name() == 'Web': # File system for web exports
		var file_dialog = HTML5FileDialog.new()
		file_dialog.filters.append(".json")
		add_child(file_dialog)
		file_dialog.show()
		var file_data: HTML5FileHandle = await file_dialog.file_selected
		var string_data = await file_data.as_text()
		# Now I can turn the string data into a json, then into a dictionary, and feeding it into load_save
		# I might need to turn the json parsing into its own function to prevent duplicate files
		var parsed_data: Dictionary = _parse_data(string_data)
		print(str("Successfully imported this data: ", parsed_data))
		save_game(parsed_data, slot)
		load_save(game_data, slot)

	else: push_error("Error trying to import save file: unsupported device")

func _parse_data(data: String) -> Dictionary:
	var json = JSON.new()
	if json.parse(data) == OK:
		var parsed_data: Dictionary = json.get_data()
		for key in parsed_data:
			if typeof(parsed_data[key]) == TYPE_DICTIONARY and parsed_data[key].has("type") == true: # Check for known Variants to convert back
				match parsed_data[key]["type"]:
					"Vector2": parsed_data[key] = _dict_to_vec2(parsed_data[key])
					"Vector3": parsed_data[key] = _dict_to_vec3(parsed_data[key])
					"Color": parsed_data[key] = _dict_to_color(parsed_data[key])
					"int": parsed_data[key] = _dict_to_int(parsed_data[key])
		parsed_data.sort()
		print(str("Data has been parsed into a Dictionary: ", parsed_data))
		return parsed_data
	else:
		push_error(str("Error parsing string: ", json.get_error_message()))
		return {}

# Functions to handle Variants unsupported by JSON
# Stored as dictionaries and recognized by key "type" : "Variant"

func _int_to_dict(i: int) -> Dictionary:
	return {"type": "int", "value": i}

func _dict_to_int(d: Dictionary) -> int:
	return int(d["value"])

func _vec3_to_dict(v: Vector3) -> Dictionary:
	return {"type": "Vector3", "x": v.x, "y": v.y, "z": v.z}
	
func _dict_to_vec3(d: Dictionary) -> Vector3:
	return Vector3(
		d.get("x", 0.0),
		d.get("y", 0.0),
		d.get("z", 0.0)
	)
	
func _vec2_to_dict(v: Vector2) -> Dictionary:
	return {"type": "Vector2", "x": v.x, "y": v.y}
	
func _dict_to_vec2(d: Dictionary) -> Vector2:
	return Vector2(
		d.get("x", 0.0),
		d.get("y", 0.0)
	)

func _color_to_dict(c: Color) -> Dictionary:
	return {"type": "Color", "html": c.to_html()}  # https://forum.godotengine.org/t/save-color-to-json-file/13745/2
	
func _dict_to_color(d: Dictionary) -> Color:
	return Color(d["html"])
