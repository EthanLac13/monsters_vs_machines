extends Node

# Loads from a JSON file
func load_json_file(json_path):
	#print(json_path)
	var json_as_text = FileAccess.get_file_as_string(json_path)
	var json_data = JSON.parse_string(json_as_text)
	return json_data

# Saves to JSON file
func save_json_file(json_data, file_to_save_to):
	if json_data != null:
		var data_as_text = JSON.stringify(json_data)
		data_as_text = JSONBeautifier.beautify_json(data_as_text)
		var save_file = FileAccess.open(file_to_save_to, FileAccess.WRITE)
		save_file.store_line(data_as_text)
	else:
		printerr("ERROR: Tried to save null data!")
