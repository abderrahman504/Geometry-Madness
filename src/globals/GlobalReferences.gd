extends Node

var difficulty : int = 3

# Scenes

var main_menu_scene : String = "res://src/main_menu/MainMenu.tscn"
var main_level_scene : String = "res://src/world/MainWorld.tscn"

var sceneRoot : World; # This is a variable that contains the root of the world scene
var game_ui : GameUI
var level_tilemap : LevelTileMap
var player : CharacterBody2D;
var playerExists : bool = false;
var bullet : String = "res://src/misc/Bullet.tscn";#The bullet scene path
var healthbarPath : String = "res://src/misc/HealthBar.tscn";
var hitEffect : String = "res://src/effects/HitEffect.tscn";
var shatterEffect : String = "res://src/effects/ShatterEffect.tscn";
var healthPickupPath : String = "res://src/pickups/HealthPickup.tscn";
var GunPaths : Dictionary = {
	GUNTYPES.Shotgun    : "res://src/guns/Shotgun.tscn",
	GUNTYPES.Machinegun : "res://src/guns/Machinegun.tscn",
	GUNTYPES.Pistol     : "res://src/guns/Pistol.tscn",
	GUNTYPES.SplitRifle : "res://src/guns/SplitRifle.tscn",
	GUNTYPES.HeavyCanon : "res://src/guns/HeavyCanon.tscn",
	GUNTYPES.Mixed      : "res://src/guns/MixedGun.tscn"
};


#Colour-to-gun mapping
enum GUNTYPES {Machinegun, HeavyCanon, SplitRifle, Shotgun, Pistol, Mixed} 
enum COLOURS {None = -1, Red, Blue, Yellow, Green, Grey, Orange}
var colours : PackedColorArray = PackedColorArray([Color("f60c0c"), Color("174fe4"), Color("f6f918"), Color("00aea5"), Color("666666"), Color("e87d00")])
var colourToGunMap : Array = [
	{"gun": GUNTYPES.Machinegun, "colour": COLOURS.Red}, 
	{"gun": GUNTYPES.HeavyCanon, "colour": COLOURS.Blue}, 
	{"gun": GUNTYPES.Pistol, "colour": COLOURS.Grey}, 
	{"gun": GUNTYPES.Shotgun, "colour": COLOURS.Green}, 
	{"gun": GUNTYPES.SplitRifle, "colour": COLOURS.Yellow}]





func _ready() -> void:
	SettingsManager.attribute_updated.connect(func(attr, val): if (attr == "Difficulty"): _on_difficulty_changed(val))
	if SettingsManager.get_attribute("Difficulty") != null:
		difficulty = SettingsManager.get_attribute("Difficulty")


func _on_difficulty_changed(value : int) -> void:
	difficulty = value
