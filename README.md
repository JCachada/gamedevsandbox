# Untitled Game - Main Development Repository

This is the main development repository for the an as of yet untitled game.

## Who do I contact with questions

The game's main developer is João Cachada. You can reach him at github.com/JCachada.

## Game Concept

Untitled Game is a narrative-driven experience with roguelike combat elements.

The main concept of the game is a corruption system built around map nodes. The game is planned to have 6-8 playable nodes, each of them taking around 2 hours to complete. The player is not meant to complete all of the nodes in one run. The player's decisions in one node's storyline affect the overall story, and how quickly the corruption levels rise both on that node and on surrounding nodes. The corruption level of nodes is persistent when the player dies.

How corrupt the nodes are affects the story and combat in those nodes. For instance, the populace of a node might be cheery and helpful on game start, but become less forgiving, hostile and nihilistic once corrupted. Enemies might be easy or few in a non-corrupted node, but bigger, stronger and nastier in corrupted nodes.

Upon death, the player doesn't simply die. Rather, the corruption level of every node rises. How much the corruption of the nodes rises depends on the cause for the player's death.

Travelling between nodes is possible at any time, but uses up time. After a given, set amount of time, the run ends. If the player dies, the timer resets. If the player doesn't die, he eventually reaches a story-related screen that causes him to restart his run and all nodes to change. The first time this happens, cutscenes explain the mechanic.

Travelling between nodes can cause story events to trigger.

Eventually, the player reaches his last run. On his last run, death is more punishing. When the player completes the last run, he gets an ending depending on several variables and his performance throughout the game.

## Tech stack

The game is developed using Godot Engine, version 3.1, stable release. It is developed using Godot's proprietary language, GDScript, which shares syntax similarities with Python. Some performance-sensitive parts of the game might be written in C#.

## License

All rights reserved. You may not distribute, share or in any way commercialize the contents of this repository without express, written permission by the repository's owner. 