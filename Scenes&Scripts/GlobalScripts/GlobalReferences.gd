extends Node

# Scenes

var main_menu_scene : String = "res://Scenes&Scripts/MainMenu/MainMenu.tscn"
var main_level_scene : String = "res://Scenes&Scripts/World/MainWorld.tscn"

var sceneRoot : World; # This is a variable that contains the root of the world scene
var game_ui : GameUI
var level_tilemap : LevelTileMap
var player : CharacterBody2D;
var playerExists : bool = false;
var bullet : String = "res://Scenes&Scripts/Other/Bullet.tscn";#The bullet scene path
var healthbarPath : String = "res://Scenes&Scripts/Other/HealthBar.tscn";
var hitEffect : String = "res://Scenes&Scripts/Other/HitEffect.tscn";
var shatterEffect : String = "res://Scenes&Scripts/Other/ShatterEffect.tscn";
var healthPickupPath : String = "res://Scenes&Scripts/Pickups/HealthPickup.tscn";
var GunPaths : Dictionary = {
	GUNTYPES.Shotgun    : "res://Scenes&Scripts/Guns/Shotgun.tscn",
	GUNTYPES.Machinegun : "res://Scenes&Scripts/Guns/Machinegun.tscn",
	GUNTYPES.Pistol     : "res://Scenes&Scripts/Guns/Pistol.tscn",
	GUNTYPES.SplitRifle : "res://Scenes&Scripts/Guns/SplitRifle.tscn",
	GUNTYPES.HeavyCanon : "res://Scenes&Scripts/Guns/HeavyCanon.tscn",
	GUNTYPES.Mixed      : "res://Scenes&Scripts/Guns/MixedGun.tscn"
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






