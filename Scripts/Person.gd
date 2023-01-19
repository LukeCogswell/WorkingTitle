extends KinematicBody2D

var direction = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
export var speed = 20

func _ready():
	randomize()

func _physics_process(delta):
	if rand_range(0, 100) < 10:
		direction = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized()
	
	move_and_slide(direction * speed)
