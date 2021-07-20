extends StaticBody2D


enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var computer_fixed = false
var dialoguePopup
var player

enum Potion { HEALTH, MANA }

func _ready():
	dialoguePopup = get_tree().root.get_node("Root/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")


func talk(answer = ""):
	# Set Fiona's animation to "talk"
	$AnimatedSprite.play("talk")
	
	# Set dialoguePopup npc to Fiona
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Fiona"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hey temp, could you fix my computer?"
					dialoguePopup.answers = "[A] Yes  [B] No"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Thanks"
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Well nobody is going anywhere until it's fixed"
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Did you fix the computer?"
					if computer_fixed:
						dialoguePopup.answers = "[A] Yes  [B] No"
					else:
						dialoguePopup.answers = "[A] No"
					dialoguePopup.open()
				1:
					if computer_fixed and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "Gee thanks. Here's a keycard, go check if something else needs fixing."
						dialoguePopup.answers = "[A] Thanks"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.dialogue = "Well, maybe you should go do it then?"
						dialoguePopup.answers = "[A] OK"
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
					# Add potion and XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					player.add_potion(Potion.HEALTH)
					player.add_xp(50)
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Thanks again for your help!"
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")


func to_dictionary():
	return {
		"quest_status" : quest_status,
		"computer_fixed" : computer_fixed
	}


func from_dictionary(data):
	computer_fixed = data.computer_fixed
	quest_status = int(data.quest_status)
