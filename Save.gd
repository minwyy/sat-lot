extends Resource
class_name Save

const SAVE_GAME_PATH := "user://SaveGame.tres"
@export  var number_data: Array[Number]

#func write_savegame() -> void:
	#ResourceSaver.save(SAVE_GAME_PATH, self)
