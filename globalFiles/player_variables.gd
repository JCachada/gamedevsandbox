extends Node

## This node is used to store variables that need to persist between multiple scenes.

var currentScene; # The scene the player was in at the time of saving.
var playerHealth = 100; # The health of the player character.
var kickedChest = false; 