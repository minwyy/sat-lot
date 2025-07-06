extends Control

const NUM_REELS = 3
const NUM_SYMBOLS_PER_REEL = 3

var reel_scene = preload("res://scenes/Reel.tscn")
var numbers_inventory = preload("res://NumbersInventory1.tres")


@onready var reels_container = $ReelsContainer
@onready var spin_button = $SpinButton

func _ready() -> void:
	randomize()
	#Load the number inventory
	for filePath in DirAccess.get_files_at("res://resources/"):
		if filePath.get_extension() == "tres":
			#print(filePath)
			numbers_inventory.number_data.append(load("res://resources/"+filePath))
	
	for i in range(NUM_REELS):
		var new_reel = reel_scene.instantiate()
		reels_container.add_child(new_reel)
		new_reel.populate_reel(numbers_inventory.number_data, NUM_SYMBOLS_PER_REEL)
	spin_button.pressed.connect(start_spin_process)

#func connect_signals() -> void:
	#GlobalSignals.SpinButtonPressed.connect(start_spin_process);

func start_spin_process() -> void:
	print("button pressed")
	for reel in reels_container.get_children():
		reel.spin(numbers_inventory.number_data)
