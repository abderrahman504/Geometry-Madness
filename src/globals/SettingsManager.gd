extends Node
# Singleton script

## Manages the different settings of the game

## Emitted when the value of an attribute is changed.
signal attribute_updated(attr : String, value)

enum AttributeType {INT, FLOAT, ENUMERATION, BOOL}

enum SetAttributeError {OK, ATTR_NOT_REGISTERED, INVALID_VALUE, }

var _settings_path : String = "user://settings.ini"

## Stores information about registered attributes like type and type-specific data.
var _registered_attrs : Dictionary

## Stores the values of registered attributes.
var _attribute_values : Dictionary

## Buffers attribute values that are loaded from disk until the attribute is registered
var _loaded_values : Dictionary

var _set_attr_error : SetAttributeError = SetAttributeError.OK


func _ready() -> void:
	_load_settings()

## Registers a new float-type attribute.
## Returns false if an attribute with the same name is already registered.
func register_float_attribute(attribute : String, default : float, min_val : float, max_val : float) -> bool:
	assert(default >= min_val && default <= max_val, "Registered float attribute %s has default value %f but specified range is %f - %f" % [attribute, default, min_val, max_val])
	if _registered_attrs.has(attribute):
		return false
	
	_registered_attrs[attribute] = {
		"type" : AttributeType.FLOAT,
		"default" : default,
		"min" : min_val,
		"max" : max_val
	}
	
	if _loaded_values.has(attribute) and _is_value_valid_for_attribute(attribute, _loaded_values[attribute]):
		_attribute_values[attribute] = _loaded_values[attribute]
		_loaded_values.erase(attribute)
	else:
		_attribute_values[attribute] = default

	attribute_updated.emit(attribute, default)

	return true


## Registers a new int-type attribute.
## Returns false if an attribute with the same name is already registered.
func register_int_attribute(attribute : String, default : int, min_val : int, max_val : int) -> bool:
	assert(default >= min_val && default <= max_val, "Registered int attribute %s has default value %d but specified range is %d - %d" % [attribute, default, min_val, max_val])
	if _registered_attrs.has(attribute):
		return false
	
	_registered_attrs[attribute] = {
		"type" : AttributeType.INT,
		"default" : default,
		"min" : min_val,
		"max" : max_val
	}

	if _loaded_values.has(attribute) and _is_value_valid_for_attribute(attribute, _loaded_values[attribute]):
		_attribute_values[attribute] = _loaded_values[attribute]
		_loaded_values.erase(attribute)
	else:
		_attribute_values[attribute] = default

	attribute_updated.emit(attribute, default)

	return true


## Registers a new boolean-type attribute.
## Returns false if an attribute with the same name is already registered.
func register_bool_attribute(attribute : String, default : bool) -> bool:
	if _registered_attrs.has(attribute):
		return false
	
	_registered_attrs[attribute] = {
		"type" : AttributeType.BOOL,
		"default" : default
	}

	if _loaded_values.has(attribute) and _is_value_valid_for_attribute(attribute, _loaded_values[attribute]):
		_attribute_values[attribute] = _loaded_values[attribute]
		_loaded_values.erase(attribute)
	else:
		_attribute_values[attribute] = default

	attribute_updated.emit(attribute, default)

	return true


## Register a new enumeration attribute. Enumeration attributes are restricted by a predefined set of values.
## Returns false if an attribute with the same name is already registered.
func register_enum_attribute(attribute : String, default : String, values : Array[String]) -> bool:
	assert(values.has(default), "Registered enum attribute %s has default value %s not in specified values %s" % [attribute, default, str(values)])
	
	if _registered_attrs.has(attribute):
		return false
	
	_registered_attrs[attribute] = {
		"type" : AttributeType.ENUMERATION,
		"default" : default,
		"values" : values
	}

	if _loaded_values.has(attribute) and _is_value_valid_for_attribute(attribute, _loaded_values[attribute]):
		_attribute_values[attribute] = _loaded_values[attribute]
		_loaded_values.erase(attribute)
	else:
		_attribute_values[attribute] = default

	attribute_updated.emit(attribute, default)
	
	return true	


## Set the value of an attribute. Returns true if successful, and false otherwise. 
## Use [code]get_error()[/code] to get a reason for the failure.
func set_attribute(attribute : String, new_value) -> bool:
	if not _registered_attrs.has(attribute):
		_set_attr_error = SetAttributeError.ATTR_NOT_REGISTERED
		return false
	if not _is_value_valid_for_attribute(attribute, new_value):
		_set_attr_error = SetAttributeError.INVALID_VALUE
		return false
	
	var old = _attribute_values[attribute]
	_attribute_values[attribute] = new_value
	if (old != new_value):
		attribute_updated.emit(attribute, new_value)
	_set_attr_error = SetAttributeError.OK
	return true
		

## Used to return the latest error from a [code]set_attribute[/code] call
func get_error() -> SetAttributeError:
	return _set_attr_error


## Loads settings from disk.
func _load_settings() -> void:
	var fh := ConfigFile.new()
	var res := fh.load(_settings_path)
	if res != OK:
		return
	
	for section in fh.get_sections():
		for key in fh.get_section_keys(section):
			_loaded_values[key] = fh.get_value(section, key)


## Saves current settings to disk
func save_settings() -> void:
	var fh := ConfigFile.new()
	
	for attr in _attribute_values:
		fh.set_value("Game", attr, _attribute_values[attr])
	
	fh.save(_settings_path)



func _is_value_valid_for_attribute(attribute : String, value) -> bool:
	if not _registered_attrs.has(attribute):
		return false
	var type : AttributeType = _registered_attrs[attribute]
	match(type):
		AttributeType.FLOAT:
			if (not (value is float or value is int) or
			value > _registered_attrs[attribute].max or 
			value < _registered_attrs[attribute].min):
				return false
		AttributeType.INT:
			if (not value is int or
			value > _registered_attrs[attribute].max or 
			value < _registered_attrs[attribute].min):
				return false
		AttributeType.BOOL:
			if not value is bool:
				return false
		AttributeType.ENUMERATION:
			if not _registered_attrs[attribute].values.has(value):
				return false
	return true