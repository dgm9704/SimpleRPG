extends KinematicBody2D

signal player_stats_changed

# Player movement speed
export var speed = 75

# Player stats
var health = 100
var health_max = 100
var health_regeneration = 1
var mana = 100
var mana_max = 100
var mana_regeneration = 2

# Player dragging flag
var drag_enabled = false
var last_direction = Vector2(0, 1)
var attack_playing = false

# Attack variables
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_damage = 30

func _ready():
	emit_signal("player_stats_changed", self)
	
func _process(delta):
	# Regenerates mana
	var new_mana = min(mana + mana_regeneration * delta, mana_max)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)

	# Regenerates health
	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)
			
func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta

	# If dragging is enabled, use mouse position to calculate movement
	if drag_enabled:
		var new_position = get_global_mouse_position()
		movement = new_position - position;
		if movement.length() > (speed * delta):
			movement = speed * delta * movement.normalized()
	
	if attack_playing:
		movement = 0.3 * movement
		
	move_and_collide(movement)
	
	# Animate player based on direction
	if not attack_playing:
		animates_player(direction)
		
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 8

func animates_player(direction: Vector2):
	
	if direction != Vector2.ZERO:
		# gradually update last_direction to counteract the bounce of the analog stick
		last_direction = 0.5 * last_direction + 0.5 * direction
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		
		$Sprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		
		# Play the walk animation
		$Sprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$Sprite.play(animation)
		
func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			drag_enabled = event.pressed

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			drag_enabled = false
	if event.is_action_pressed("attack"):
		attack_playing = true
		var animation = get_animation_direction(last_direction) + "_attack"
		$Sprite.play(animation)
	elif event.is_action_pressed("fireball"):
		if mana >= 25:
			mana = mana - 25
			emit_signal("player_stats_changed", self)
			attack_playing = true
			var animation = get_animation_direction(last_direction) + "_fireball"
			$Sprite.play(animation)
	if event.is_action_pressed("attack"):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# What's the target?
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Skeleton") >= 0:
					# Skeleton hit!
					target.hit(attack_damage)
			# Play attack animation
			attack_playing = true
			var animation = get_animation_direction(last_direction) + "_attack"
			$Sprite.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time


func _on_Sprite_animation_finished():
	attack_playing = false
