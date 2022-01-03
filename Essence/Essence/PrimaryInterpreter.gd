extends Node

# /// TO DO: ///
# - variable manipulation
# - choices and dialogue branching

export var script_file = "res://script_test.tres" # Load your script file into here

var dialogue_script = {}

var shard_name
var speaker
var event
var text

var counter = 0

func _ready():
	read_txt(script_file)

# --- Parsing the txt file and putting it into the data structure ---

func read_txt(f):
	var file = File.new()
	file.open(f, file.READ)

	while not file.eof_reached():
		# A new dictionary is created at the shard name everytime the while loop loops
		if counter > 0:
			dialogue_script[shard_name].append({})

		var line = file.get_line()
		
		if "$" in line: # Locating shards
			shard_name = line.split("$")[1]
			dialogue_script[shard_name] = [{}]

		elif "::" in line: # Locating dialogue line with speaker
			if "[" and "]" in line: # Identifying if events are present
				var bt = line.split("::")[0]

				var occurances = line.count("[") # Checking if there is more than one event on a line
				for i in range(occurances):
					var e = bt.split("]")[i] # Isolating events
					event = e.split("[")[1]
					add_to_script("event" + str(i+1), event)
				
				speaker = bt.split("[")[0]
				if speaker != "": # In case an event is present, but not a speaker
					add_to_script("speaker", speaker)
			else:
				speaker = line.split("::")[0] # If no events are present, but a speaker is present
				add_to_script("speaker", speaker)
			text = line.split("::")[1] # Locating text
			add_to_script("text", text)
			
		else:
			if not line.empty():
				text = line # If a speaker is not present
				add_to_script("text", text)
		
		counter += 1

	file.close()

func add_to_script(type, data):
	dialogue_script[shard_name][counter - 1][type] = data # Adds the data as a value and the type as a key into the inner-most dictionary
