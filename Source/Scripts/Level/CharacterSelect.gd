extends Node2D


export var music = preload("res://Audio/Soundtrack/10. SWD_CharacterSelect.ogg")
export (PackedScene) var nextZone = load("res://Scene/Zones/DoubleZone.tscn")
var selected = false

# character labels, the amount of labels in here determines the total amount of options, see the set character option at the end for settings
var characterLabels = ["Sonic and Tails", "Sonic", "Tails", "Knuckles"]
# character id lines up with characterLabels
var characterID = 0

func _ready():
	Global.music.stream = music
	Global.music.play()
	$UI/Labels/Control/Character.string = characterLabels[characterID]
	if nextZone != null:
		Global.nextZone = nextZone

func _input(event):
	if !selected:
		# select character rotation
		if Input.is_action_just_pressed("gm_left"):
			characterID = wrapi(characterID-1,0,characterLabels.size())
		if Input.is_action_just_pressed("gm_right"):
			characterID = wrapi(characterID+1,0,characterLabels.size())
		
		$UI/Labels/Control/Character.string = characterLabels[characterID]
		
		# turn on and off visibility of the characters based on the current selection
		match(characterID):
			0: # Sonic and Tails
				$UI/Labels/CharacterOrigin/Sonic.visible = true
				$UI/Labels/CharacterOrigin/Tails.visible = true
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
			1: # Sonic
				$UI/Labels/CharacterOrigin/Sonic.visible = true
				$UI/Labels/CharacterOrigin/Tails.visible = false
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
			2: # Tails
				$UI/Labels/CharacterOrigin/Sonic.visible = false
				$UI/Labels/CharacterOrigin/Tails.visible = true
				$UI/Labels/CharacterOrigin/Knuckles.visible = false
			3: # Knuckles
				$UI/Labels/CharacterOrigin/Sonic.visible = false
				$UI/Labels/CharacterOrigin/Tails.visible = false
				$UI/Labels/CharacterOrigin/Knuckles.visible = true
		
		# finish character select if start is pressed
		if event.is_action_pressed("gm_pause"):
			selected = true
			# set player 2 to none to prevent redundant code
			Global.PlayerChar2 = Global.CHARACTERS.NONE
			
			# set the character
			match(characterID):
				0: # Sonic and Tails
					Global.PlayerChar1 = Global.CHARACTERS.SONIC
					Global.PlayerChar2 = Global.CHARACTERS.TAILS
				1: # Sonic
					Global.PlayerChar1 = Global.CHARACTERS.SONIC
				2: # Tails
					Global.PlayerChar1 = Global.CHARACTERS.TAILS
				3: # Knuckles
					Global.PlayerChar1 = Global.CHARACTERS.KNUCKLES
			
			Global.main.change_scene(Global.nextZone,"FadeOut","FadeOut","SetSub",1)
