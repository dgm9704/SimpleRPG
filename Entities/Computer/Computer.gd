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


func talk(answer = ""):
	
	# Set dialoguePopup npc to Computer
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Computer"
	
	# Show the current dialogue
	match repair_status:
		RepairStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Blue Screen Of Death"
					dialoguePopup.answers = "[A] Try to fix it  [B] Leave it alone"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							dialogue_state = 0
							repair_status = RepairStatus.STARTED
							dialoguePopup.dialogue = "You have no idea how to proceed but try anyway"
							dialoguePopup.answers = "[A] OK"
							dialoguePopup.open()
						"B":
							dialogue_state = 0
							dialoguePopup.close()
		RepairStatus.STARTED:
			match dialogue_state:
				0: 
					dialogue_state = 1
					dialoguePopup.dialogue = "The screen glows blue at you."
					dialoguePopup.answers = """[A] Press random keys [B] Turn it off and on again 
					[C] Forget it"""
					dialoguePopup.open()
				1:
					match answer:
						"A": 
							dialogue_state = 0
							dialoguePopup.dialogue = "Nothing happens. You had no expectations, yet are still disappointed."
							dialoguePopup.answers = "[A] OK"
							dialoguePopup.open()
						"B": 
							repair_status = RepairStatus.COMPLETED
							dialogue_state = 0
							dialoguePopup.dialogue = """The computer takes forever to come back on.
							For some reason the screen is not blue anymore."""
							dialoguePopup.answers = "[A] OK"
							dialoguePopup.open()
						"C": 
							dialogue_state = 0
							repair_status = RepairStatus.NOT_STARTED
							dialoguePopup.close()
		RepairStatus.COMPLETED:
			match dialogue_state:
				0:
					dialoguePopup.dialogue = "You look at the screen, and smile just a little"
					dialoguePopup.answers = "[A] OK"
