extends Area2D

@export var player_speed = 400
@export var radiant_speed = PI * 1.5

signal bullet_shot(parent, bullet)

@export var bullet_scene : PackedScene
var cannon_switch = false
var is_on_cooldown = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(delta):	
	turn(delta)
	move(delta)
	if(not is_on_cooldown):
		if(Input.is_action_pressed("shoot")):
			shoot()

func turn(delta):
	var direction = 0
	if(Input.is_action_pressed("left")):
		direction = -1
	if(Input.is_action_pressed("right")):
		direction = 1
	rotation += direction * radiant_speed * delta

func move(delta):
	var direction = Vector2.ZERO
	if(Input.is_action_pressed("move_up")):
		direction += Vector2.UP
	if(Input.is_action_pressed("move_down")):
		direction += Vector2.DOWN
	if(Input.is_action_pressed("move_right")):
		direction += Vector2.RIGHT
	if(Input.is_action_pressed("move_left")):
		direction += Vector2.LEFT
	var move_vector = direction * player_speed * delta
	position += move_vector
	
	if(move_vector.length() > 0):
		$AnimatedSprite2D.play("flying")
	else:
		$AnimatedSprite2D.play("idle")

func shoot():
	is_on_cooldown = true
	$BulletCooldown.start()
	
	var bullet = bullet_scene.instantiate()
	var start
	if(cannon_switch):
		start = $BulletSpawnLeft.position
	else:
		start = $BulletSpawnRight.position
	cannon_switch = not cannon_switch
	bullet.position = start
	bullet.rotation = rotation
	bullet_shot.emit(self, bullet)
	
	await $BulletCooldown.timeout
	is_on_cooldown = false
