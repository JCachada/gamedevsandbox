# Node 00  - Tutorial Node

## Node description / Purpose

The main purpose of this node is to serve as an introductory node for the game. It introduces the basic controls for movement, interaction, and combat. It introduces the main character and the main scenario that will compose the game's story. It is also the first node at which the player arrives after each run, that is, after the corruption level increases in the world. As such, it is also the first place to exhibit changes.

Besides all that, it is the node where the player's home is. That means that, at least at the beginning, it is where the player's family resides.

## Main Story Events in this node

### Starting corruption

* Character introduction;
* Character's family's introduction (wife and son);
* Character's village's introduction;
* **Introduction of the threat of the corruption**;
* **Beginning of the player's journey to escape the corruption**;

## Combat Events in this node

### Starting corruption

* Tutorial bandit encounter;

## Environment / Atmosphere

### Starting corruption

This is a small village relatively removed from the confusion of the capital and the big cities. There is a heightened sense of community here - people hospitable, trustworthy and friendly. The weather is nice, warm and sunny. The lands are fertile - this is a green place, full of vegetation and tranquility. The village itself is surrounded by woods which, while untamed, have a decidedly unthreatening look about them. Cheery music will be playing - think something like Stardew Valley level of chill. Good mood references for this are The Shire at the beginning of Fellowship of the Ring, the feeling of Toussaint in Witcher 3: blood and Wine, and generally speaking the default atmosphere of cutesy simulation games. Stuff like Animal Crossing, Stardew Valley, etc.

## Mood references

Toussaint: https://s3-us-west-1.amazonaws.com/shacknews/assets/editorial/2016/12/witcher31.jpg

This image captures the green of the scenery and the feel of a relatively isolated place well.

PoE: https://gamepedia.cursecdn.com/eternitywiki/6/6c/PE1_Dyrford_Map.png

This village from Pillars of Eternity captures the above feeling of a small town as well without being as green, but maintaining the still isolated and homey feeling.

## Scene structure

![alt text](https://i.imgur.com/h5FrI0q.png "Structure")

Pardon the horrible paint mockup, and obviously there will be some blank space between the different assets for the player to walk in. However, this is the bulk of the first node's (tutorial) structure. Two other scenes will be necessary: the combat scene where the tutorial combat will take place, and a small mocked inside of the player's home, with the player's wife inside.

All in all, this scene requires:

- Background
- 4 Sprites, idle animation only: The guard, the elder and his wife, and the player's wife.
- 1 Sprite (the boy), with a running animation.
- The sprites for the outside of the homes. I'm either fine with actual house sprites to be inserted into the scene (repeated are fine), or tiles for me to build the homes.

The player's wife and the boy have dedicated mood documents to consult. The elder, his wife and the guard are somewhat generic village NPCs, and should mostly follow the style established by the important characters (like the MC's wife, the MC and his son.)

For extra detailed information, the script can be consulted.