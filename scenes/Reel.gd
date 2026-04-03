extends Control

var symbol_scene = preload("res://scenes/Symbol.tscn")
@onready var symbols_container = %SymbolsContainer

func populate_reel(number_inventory_data, num_symbols):
	for i in range(num_symbols):
		var new_symbol = symbol_scene.instantiate()
		var random_symbol_texture = number_inventory_data[randi() % number_inventory_data.size()].item_texture
		new_symbol.texture = random_symbol_texture
		new_symbol.z_index = 0

		symbols_container.add_child(new_symbol)

#@onready var tween = $Tween

func spin(numbers_inventory_data, reel_number, used_numbers):
	# 1. Create a new Tween
	var tween = create_tween()
	
	# 2. Set up spin properties
	var spin_duration = 1.2  # Total duration of the spin
	var blur_reps = 5      # How many times the reel will loop to create a blur effect
	var symbol_height = symbols_container.get_child(0).get_size().y
	var reel_height = symbol_height * symbols_container.get_child_count()
	if reel_number == 6:
		spin_duration = 1.6
		blur_reps = 6
	# 3. Animate the blur effect
	# We loop multiple times, moving the container down its full height each time
	for i in range(blur_reps):
		tween.tween_property(symbols_container, "position:y", reel_height, spin_duration / blur_reps)
		tween.tween_callback(func(): randomize_symbols(numbers_inventory_data, [])) # Change symbols before the final spin
		tween.tween_callback(func(): symbols_container.position.y = 0) # Reset position instantly for the next loop

	# 4. Animate the final stop
	# After the blur, we do one final spin that lands on the resultp
	tween.tween_callback(func(): randomize_symbols(numbers_inventory_data, used_numbers)) # Change symbols before the final spin
	tween.tween_property(symbols_container, "position:y", 0, spin_duration).from(-reel_height/1.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	# 5. Wait for the tween to finish and emit the signal
	await tween.finished
	
	# Reset position after the final spin
	symbols_container.position.y = 0
	#used_numbers = []
	if reel_number == 6:
		GlobalSignals.ReelsStopped.emit(used_numbers)

func randomize_symbols(numbers_inventory_data, used_numbers):
	#print(numbers_inventory_data[0].item_name)
	#print("generating new numbers")
	#print(used_numbers.size())
	#print("herehere")
	for symbol in symbols_container.get_children():
		#var random_symbol = numbers_inventory_data[randi() % numbers_inventory_data.size()]
		var random_symbol = get_random_element_not_in_other_array(numbers_inventory_data, used_numbers)
		symbol.texture = random_symbol.item_texture
		used_numbers.append(random_symbol)
		#print("herehere0 "+str(used_numbers.size()))
		#print(random_symbol.item_name)

func get_random_element_not_in_other_array(source_array: Array, exclusion_array: Array):
	# Create a temporary array of elements from source_array that are NOT in exclusion_array
	var valid_elements = []
	for element in source_array:
		if not exclusion_array.has(element):
			valid_elements.append(element)

	# Check if there are any valid elements left
	if valid_elements.is_empty():
		return null # No unique elements found

	# Pick a random element from the filtered list
	#print(source_array.size())
	var random_index = randi() % valid_elements.size()
	#print(random_index)
	return valid_elements[random_index]
