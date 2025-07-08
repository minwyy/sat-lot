extends Control

const NUM_REELS = 7
const NUM_SYMBOLS_PER_REEL = 3

var reel_scene = preload("res://scenes/Reel.tscn")
var Symbol = preload("res://scenes/Symbol.tscn")
var numbers_inventory = preload("res://NumbersInventory1.tres")
@onready var my_preloader = %ResourcePreloader

#@onready var reels_container = $ReelsContainer
#@onready var spin_button = $SpinButton

func _ready() -> void:
	%SpinButton.pressed.connect(start_spin_process)
	%LoadButton.pressed.connect(load_numbers)
	GlobalSignals.ReelsStopped.connect(save_numbers)
	randomize()

	#reels_container.
	#Load the number inventory
	#for filePath in DirAccess.get_files_at("res://resources/"):
		#print(filePath)
		#if filePath.get_extension():
			#numbers_inventory.number_data.append(load("res://resources/"+filePath))
	# Loop through each name and retrieve the actual resource
	var resource_names: PackedStringArray = my_preloader.get_resource_list()
	#print(resource_names.size())
	for name in resource_names:
		var resource = my_preloader.get_resource(name)
		print("  - Name: ", name, ", Resource Type: ", resource.get_class())
		var new_number = Number.new()
		new_number.item_name = name
		new_number.item_texture = resource
		numbers_inventory.number_data.append(new_number)
	#print(numbers_inventory.number_data.size())
	var saved_game: Save = load("user://save.tres")
	for i in range(NUM_REELS):
		var new_reel = reel_scene.instantiate()
		#new_reel.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		%ReelsContainer.add_child(new_reel)
		new_reel.populate_reel(numbers_inventory.number_data, NUM_SYMBOLS_PER_REEL)


#func connect_signals() -> void:
	#GlobalSignals.SpinButtonPressed.connect(start_spin_process);

func start_spin_process() -> void:
	print("button pressed")
	var i = 0
	var used_numbers : Array[Number]
	for reel in %ReelsContainer.get_children():
		await get_tree().create_timer(i * 0.005).timeout # Wait for 1 second
		reel.spin(numbers_inventory.number_data, i, used_numbers)
		i = i + 1
		#print(used_numbers.size())

	used_numbers = []
	

func load_numbers() -> void:
	print("start loading numbers")
	var saved_game: Save = load("user://save.tres")
	for reel in %ReelsContainer.get_children():
		for symbol in reel.get_child(0).get_children():
			#print(symbol)
			symbol.texture = saved_game.number_data.pop_front().item_texture
			
	#saved_game.
func save_numbers(used_numbers) -> void:
	var odds = randi() % 100
	if  odds > 33:
		print(odds)
		print("bad odds, re-roll")
		start_spin_process()
	else:
		print("start saving")
		print(used_numbers.size())
		var new_save = Save.new();
		new_save.number_data = used_numbers
		ResourceSaver.save(new_save, "user://save.tres")
