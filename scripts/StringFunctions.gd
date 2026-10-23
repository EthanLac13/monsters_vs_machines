extends Node

class_name StringData

static var language

const GLOBAL_STRINGS_PATH_TEMPLATE = "res://data/strings/%s/global_strings.json"

static var strings

func _init() -> void:
	pass

# Gets a translated string, or returns a placeholder if it doesn't exist
static func get_translated_string(string_id: String, string_bank = null):
	if string_bank == null:
		string_bank = strings
	if string_bank.has(string_id):
		return string_bank[string_id]
	else:
		return "<MISSING %s>" % string_id

# Updates the language files
static func update_language(new_language: String):
	print("Changing language to: %s" % new_language)
	language = new_language
	
	strings = JSON.parse_string(FileAccess.get_file_as_string(GLOBAL_STRINGS_PATH_TEMPLATE % language))
