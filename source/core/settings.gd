extends Node

var mouse_sensitivity := 0.007
var field_of_view := 75
var enable_crosshair := true
var enable_hit_marker := true



func _ready() -> void:
	load_config()
	Signals.update_config_file.connect(save_config)


func save_config():
	var config := ConfigFile.new()
	config.set_value("Gameplay", "enable_crosshair", enable_crosshair)
	config.set_value("Gameplay", "enable_hit_marker", enable_hit_marker)
	config.set_value("Gameplay", "field_of_view", field_of_view)
	config.set_value("Controls", "mouse_sensitivity", mouse_sensitivity)
	config.set_value("Audio", "master", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	config.set_value("Audio", "ui", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("UI")))
	config.set_value("Audio", "sfx", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	config.set_value("Video", "resolution", get_tree().root.content_scale_factor)
	config.set_value("Video", "window_mode", DisplayServer.window_get_mode())
	config.set_value("Video", "borderless", DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS))
	config.save("user://anathema.cfg")


func load_config():
	var user_config := ConfigFile.new()
	var default_config := ConfigFile.new()
	var user_err := user_config.load("user://anathema.cfg")
	var default_err = default_config.load("res://default.cfg")

	if default_err != OK:
		return

	if user_err == OK:

		if user_config.has_section("Gameplay"):
			if user_config.has_section_key("Gameplay", "enable_crosshair"):
				enable_crosshair = user_config.get_value("Gameplay", "enable_crosshair")
			else:
				enable_crosshair = default_config.get_value("Gameplay", "enable_crosshair")
			if user_config.has_section_key("Gameplay", "enable_hit_marker"):
				enable_hit_marker = user_config.get_value("Gameplay", "enable_hit_marker")
			else:
				enable_hit_marker = default_config.get_value("Gameplay", "enable_hit_marker")
			if user_config.has_section_key("Gameplay", "field_of_view"):
				field_of_view = user_config.get_value("Gameplay", "field_of_view")
			else:
				field_of_view = default_config.get_value("Gameplay", "field_of_view")
		else:
			enable_crosshair = default_config.get_value("Gameplay", "enable_crosshair")
			enable_hit_marker = default_config.get_value("Gameplay", "enable_hit_marker")
			field_of_view = default_config.get_value("Gameplay", "field_of_view")

		if user_config.has_section("Controls"):
			if user_config.has_section_key("Controls", "mouse_sensitivity"):
				mouse_sensitivity = user_config.get_value("Controls", "mouse_sensitivity")
			else:
				mouse_sensitivity = default_config.get_value("Controls", "mouse_sensitivity")
		else:
			mouse_sensitivity = default_config.get_value("Controls", "mouse_sensitivity")

		if user_config.has_section("Audio"):
			if user_config.has_section_key("Audio", "master"):
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), user_config.get_value("Audio", "master"))
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), default_config.get_value("Audio", "master"))
			if user_config.has_section_key("Audio", "ui"):
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), user_config.get_value("Audio", "ui"))
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), default_config.get_value("Audio", "ui"))
			if user_config.has_section_key("Audio", "sfx"):
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), user_config.get_value("Audio", "sfx"))
			else:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), default_config.get_value("Audio", "sfx"))
		else:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), default_config.get_value("Audio", "master"))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), default_config.get_value("Audio", "ui"))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), default_config.get_value("Audio", "sfx"))

		if user_config.has_section("Video"):
			if user_config.has_section_key("Video", "resolution"):
				get_tree().root.content_scale_factor = user_config.get_value("Video", "resolution")
			else:
				get_tree().root.content_scale_factor = default_config.get_value("Video", "resolution")
			if user_config.has_section_key("Video", "window_mode"):
				DisplayServer.window_set_mode(user_config.get_value("Video", "window_mode"))
			else:
				DisplayServer.window_set_mode(default_config.get_value("Video", "window_mode"))
			if user_config.has_section_key("Video", "borderless"):
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, user_config.get_value("Video", "borderless"))
			else:
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, default_config.get_value("Video", "borderless"))
		else:
			get_tree().root.content_scale_factor = default_config.get_value("Video", "resolution")
			DisplayServer.window_set_mode(default_config.get_value("Video", "window_mode"))
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, default_config.get_value("Video", "borderless"))
	else:
		enable_crosshair = default_config.get_value("Gameplay", "enable_crosshair")
		enable_hit_marker = default_config.get_value("Gameplay", "enable_hit_marker")
		field_of_view = default_config.get_value("Gameplay", "field_of_view")
		mouse_sensitivity = default_config.get_value("Controls", "mouse_sensitivity")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), default_config.get_value("Audio", "master"))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), default_config.get_value("Audio", "ui"))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), default_config.get_value("Audio", "sfx"))
		get_tree().root.content_scale_factor = default_config.get_value("Video", "resolution")
		DisplayServer.window_set_mode(default_config.get_value("Video", "window_mode"))
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, default_config.get_value("Video", "borderless"))

	Signals.update_mouse_sensitivity_setting.emit()
	Signals.update_fov_setting.emit(field_of_view)
