extends Control

var phrases = [
	"Dreams", "Whisper", "Eternity",
	"Ocean Heart", "Light Dance", "Pathless",
	"Starshine", "Moonbeam", "Endless",
	"Mist", "Thought", "Echo",
	"Rainfall", "Horizon", "Timeless",
	"Golden Sunset", "Hidden Smile", "Frozen Moment",
	"Chasing Shadow", "Fleeting Memory", "Timeless Love",
	"Twilight Whisper", "Burning Desire", "Secret Garden",
	"Celestial Journey", "Rustling Leaf", "Tranquil Water",
	"Infinite Space", "Wandering Soul", "Midnight Serenade",
	"Broken Wing", "Soothing Silence", "Deserted Street",
	"Ancient Ruin", "Whimsical Moonlight", "Enchanted Forest",
	"Scarlet Sunrise", "Crystal Vision", "Melancholy Sky",
	"Ephemeral Beauty", "Echoing Mountain", "Sands of Time",
	"Radiant Dawn", "Mystic River", "Winter Embrace",
	"Crimson Twilight", "Lingering Gaze", "Starry Night",
	"Hushed Voice", "Veiled Shadow", "Iridescent Sky",
	"Sleeping Meadow", "Autumn Leaf", "Spring Blossom",
	"Summertime Dream", "Wistful Eye", "Blue Horizon",
	"Silver Moonbeam", "Quiet Solitude", "Flickering Flame",
	"Cherished Memory", "Whirling Wind", "Restless Tide",
	"Glittering Snowflake", "Vanishing Dream", "Sun-kissed Rain",
	"Harmonious Melody", "Glowing Hearth", "Cascading Waterfall",
	"Nostalgic Reflection", "Spectral Light", "Resonant Echo",
	"Serene Landscape", "Painted Sky", "Dewy Petal",
	"Aurora's Veil", "Fluttering Leaf", "Gentle Breeze",
	"Glimmering Star", "Whirling Dance", "Zenith",
	"Soft Murmur", "Glistening Dew", "Quiet Hush",
	"Blooming Flower", "Gleaming Light", "Pulsing Heart",
	"Sapphire Sky", "Rippling Water", "Solstice Night"
]

var amountOfPhrasesToShow = 20
var hasBeenUsed = Array()
var accumulated_text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(phrases.size()):
		hasBeenUsed.append(false)
	randomize()
	create_labels()
	update_phrases()	
	
func create_labels():
	for i in range(amountOfPhrasesToShow):
		var label = Label.new()
		add_child(label)

func update_phrases(replace_index: int = -1):
	if replace_index >= 0:
		# Replace only the specific phrase
		var label = get_child(replace_index)
		if label is Label:
			label.text = get_new_phrase()
	else:
		# Initial population or no specific phrase to replace
		var displayed_phrases = []
		while displayed_phrases.size() < amountOfPhrasesToShow:
			var index = randi() % phrases.size()
			if not hasBeenUsed[index]:
				displayed_phrases.append(phrases[index])
				hasBeenUsed[index] = false
		# Update the Labels with the new phrases
		for i in range(min(get_child_count(), amountOfPhrasesToShow)):
			var label = get_child(i)
			if label is Label:
				label.text = displayed_phrases[i]


func mark_phrase_as_used(spoken_phrase: String):
	accumulated_text += " " + spoken_phrase
	accumulated_text = accumulated_text.to_lower().strip_edges()

	for i in range(phrases.size()):
		if phrases[i].to_lower() in accumulated_text and not hasBeenUsed[i]:
			print("Phrase matches: ", phrases[i])
			hasBeenUsed[i] = true
			replace_phrase(i)
			update_phrases()
			accumulated_text = ""
			return

func replace_phrase(index: int):
	print("replacing phrase", index)
	if index < 0 or index >= phrases.size():
		print("Index out of bounds: ", index)
		return

	var newPhrase = get_new_phrase()
	print("new phrase", newPhrase)
	if newPhrase == null or newPhrase == "":
		print("New phrase is invalid.")
		return

	print("Replacing, ", phrases[index], " at index ", index, " with ", newPhrase)
	phrases[index] = newPhrase


func get_new_phrase() -> String:
	# Create a list of indices for unused phrases
	var unused_indices = []
	for i in range(phrases.size()):
		if not hasBeenUsed[i]:
			unused_indices.append(i)

	# Check if there are any unused phrases left
	if unused_indices.size() == 0:
		print("No unused phrases left.")
		return ""

	# Select a random unused phrase
	var random_index = unused_indices[randi() % unused_indices.size()]
	return phrases[random_index]

