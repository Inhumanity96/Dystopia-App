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
	was added to habdle all video playing functions. (Note: video player works best with .ogv video format)


(5) Ingame Menu:
	This is a reusable ingame menu i added to give access to all major scenes in the App


-Features to Fix
	-Globals.savegame() filesystem for android devices
	-Comics placeholder code, to use Spritesheets
	-Fix up the Game's controls to be able to control the Music and Debug nodes
	-Fix up Game's spawnpoints (look at the Exit code in the Temple interior scene)
	-Fix up game's assets and animation
	-AI mob chase / enemy state changer


-Features to Add
	-Particle effects when player attacks
	-Fix UI
	-Add multiplayer Network and DLC network code/singleton
	-Improve Loading Cinematic video
	-Guided view ( Check ://sourcefile/New game code and features)
	-Login UI
	-Mana meter (Ogun meter)
	-Enemy kill count
	-YouTube load video
	//Twitter Tweet feature//
	//Clouddust Login//
	//Wetalksound playlist feature//
	
	

Import and compile with Godot IDE
