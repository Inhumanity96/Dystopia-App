# Dystopia-App
''''
Documentation by INhumanity_arts 

''''
I Added a couple of New funtions and Global variables to help in coding
(1) Music.shuffle()
	This shuffles a selected music playlist (dictionary). It is in the Music singleton 

(2)Globals.comicbook[1]
	This is a shortcut for calling the comicbook scenes. use the change_scene_to(load(...INSERT ...)) to call it. 
	check for other callable functions and variables in the globals singleton 
(3)Debug
	It calls debug funtions like Debug.start_debug(), Debug.stop_debug(), and passes its variables to the debug panel node
	for ingame debugging(Note: improve code to be able to instance the debug panel at will)

(4) Fonts, Music and Videos
	I added a couple of new Dynamic Fonts and Music funtions that can be called from the Music track node. A cinematic scene
	was added to handle all video playing functions. (Note: video player works best with .ogv video format)


(5) Ingame Menu:
	This is a reusable ingame menu i added to give access to all major scenes in the App


(6) Custom input maps:
	Added a couple of custom input maps to enable and disable the comics and game menu scenes 

(7) Enemy kill count

(8) Twitter Login
-Features to Fix
	-Globals.savegame() filesystem for android devices
	-
	-Fix up the Game's controls to be able to control the Music node
	-Fix up Game's spawnpoints (look at the Exit code in the Temple interior scene)
	-Fix up game's assets and animation
	-auto enemy spawner
	-Idol autosave
	-A better state machine
	-Cinematic video loading code system

-Features to Add
	-New animation
	-Particle effects when player attacks
	-update control art with new button maps
	-	
	-Add multiplayer Network and DLC network code/singleton
	-
	-Guided view ( Check ://sourcefile/New game code and features)
	-Login UI
	-Mana meter (Ogun meter)
	
	-YouTube load video
	//Twitter Tweet feature//
	//Clouddust Login//
	//Wetalksound playlist feature//

[![Watch a playtest demo video](https://img.youtube.com/vi/WLTgP-Axb-g/maxresdefault.jpg)](https://youtu.be/WLTgP-Axb-g)
	

Import and compile with Godot IDE
