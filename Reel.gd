extends Node2D

var symbol_scene = preload("res://scenes/Symbol.tscn")
@onready var symbols_container = $SymbolsContainer

func populate_reel(number_inventory_data, num_symbols):
	for i in range(num_symbols):
		var new_symbol = symbol_scene.instantiate()
		symbols_container.add_child(new_symbol)
		var random_symbol_texture = number_inventory_data[randi() % number_inventory_data.size()].item_texture
		new_symbol.texture = random_symbol_texture

#@onready var tween = $Tween

func spin(numbers_inventory_data):
	# 1. Create a new Tween
	var tween = create_tween()
	
	# 2. Set up spin properties
	var spin_duration = 1.0  # Total duration of the spin
	var blur_reps = 5      # How many times the reel will loop to create a blur effect
	var symbol_height = symbols_container.get_child(0).get_size().y
	var reel_height = symbol_height * symbols_container.get_child_count()

	# 3. Animate the blur effect
	# We loop multiple times, moving the container down its full height each time
	for i in range(blur_reps):
		tween.tween_property(symbols_container, "position:y", reel_height, spin_duration / blur_reps)
		tween.tween_callback(func(): symbols_container.position.y = 0) # Reset position instantly for the next loop

	# 4. Animate the final stop
	# After the blur, we do one final spin that lands on the result
	tween.tween_callback(func(): randomize_symbols(numbers_inventory_data)) # Change symbols before the final spin
	tween.tween_property(symbols_container, "position:y", reel_height, spin_duration).from(0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

	# 5. Wait for the tween to finish and emit the signal
	await tween.finished
	
	# Reset position after the final spin
	symbols_container.position.y = 0
	
	emit_signal("stopped")

func randomize_symbols(numbers_inventory_data):
	#print(numbers_inventory_data[0].item_name)
	print("generating new numbers")
	for symbol in symbols_container.get_children():
		var random_symbol = numbers_inventory_data[randi() % numbers_inventory_data.size()]
		symbol.texture = random_symbol.item_texture
		print(random_symbol.item_name)
