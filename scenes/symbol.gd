extends TextureRect

func grey_out() -> void:
	self_modulate = Color(0.299, 0.587, 0.114, 1.0)
