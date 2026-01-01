extends Node

# Singleton script

var screenshots_path := "user://screenshots"

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(screenshots_path):
		DirAccess.make_dir_absolute(screenshots_path)


func _unhandled_input(event : InputEvent):
	if Input.is_action_just_pressed("screenshot"):
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		save_screenshot(img)
		



func save_screenshot(img : Image) -> void:
	var bytes = PackedByteArray()
	bytes.resize(8)
	bytes.encode_s64(0, randi())
	var uid : String = bytes.hex_encode().substr(0, 6)
	var path = "%s/%s_%s.png" % [screenshots_path, Time.get_datetime_string_from_system().replace(":", "-"), uid]
#	var fh := FileAccess.open(path, FileAccess.WRITE)
#	fh.close()
	var res = img.save_png(path)
	print(res)
