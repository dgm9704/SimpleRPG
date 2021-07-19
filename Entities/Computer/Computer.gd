extends StaticBody2D


enum RepairStatus { NOT_STARTED, STARTED, COMPLETED }
var repair_status = RepairStatus.NOT_STARTED
var dialogue_state = 0
var dialoguePopup
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	dialoguePopup = get_tree().root.get_node("Root/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func talk(answer = ""):
	# Set animation to "talk"
	#$AnimatedSprite.play("talk")
	
	# Set dialoguePopup npc to Fiona
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Computer"
	
	# Show the current dialogue
	match repair_status:
		RepairStatus.NOT_STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Blue Screen Of Death"
					dialoguePopup.answers = "[A] Fix it  [B] Go away"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Thank you!"
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "If you change your mind, you'll find me here."
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					repair_status = RepairStatus.STARTED
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
		RepairStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Did you find my necklace?"
					#if necklace_found:
					#	dialoguePopup.answers = "[A] Yes  [B] No"
					#else:
					#	dialoguePopup.answers = "[A] No"
					#dialoguePopup.open()
				1:
					pass
					#if necklace_found and answer == "A":
					#	# Update dialogue tree state
					#	dialogue_state = 2
					#	# Show dialogue popup
					#	dialoguePopup.dialogue = "You're my hero! Please take this potion as a sign of my gratitude!"
					#	dialoguePopup.answers = "[A] Thanks"
					#	dialoguePopup.open()
					#else:
					#	# Update dialogue tree state
					#	dialogue_state = 3
					#	# Show dialogue popup
					#	dialoguePopup.dialogue = "Please, find it!"
					#	dialoguePopup.answers = "[A] I will!"
					#	dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					repair_status = RepairStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
					# Add potion and XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					#player.add_potion(Potion.HEALTH)
					player.add_xp(50)
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					$AnimatedSprite.play("idle")
		RepairStatus.COMPLETED:
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
