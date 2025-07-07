extends Control

const NUM_REELS = 7
const NUM_SYMBOLS_PER_REEL = 3

var reel_scene = preload("res://scenes/Reel.tscn")
var numbers_inventory = preload("res://NumbersInventory1.tres")


#@onready var reels_container = $ReelsContainer
#@onready var spin_button = $SpinButton

func _ready() -> void:
	%SpinButton.pressed.connect(start_spin_process)
	randomize()
	#reels_container.
	#Load the number inventory
	for filePath in DirAccess.get_files_at("res://resources/"):
		if filePath.get_extension() == "tres":
			#print(filePath)
			numbers_inventory.number_data.append(load("res://resources/"+filePath))
	
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
	used_numbers = []
