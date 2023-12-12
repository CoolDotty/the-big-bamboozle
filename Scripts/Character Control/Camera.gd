extends Node

@export var look_target: Node

# Horizontal follow parameters
@export var horizontal_offset := 250.0  # Adjust as needed
@export var smoothing := 5.0  # Adjust as needed
var corrected_horizontal

# Vertical follow parameters
@export_range(-200,200,0.5) var vertical_offset := -100  # Adjust as needed

func _ready():
	corrected_horizontal = horizontal_offset

func _process(delta):	
	print(get_viewport().size.x)
	#another fast dirty way of making something work
	#check which side our horizontal offset should be on
	if look_target.direction == 0.0:
		pass
	elif look_target.direction < 0:
		corrected_horizontal = -horizontal_offset
	else:
		corrected_horizontal = horizontal_offset

	if look_target:
		# Smoothly follow the target horizontally
		var target_x = lerp(self.position.x, look_target.global_position.x + corrected_horizontal, delta * smoothing)
		self.position.x = target_x

		var target_y = lerp(self.position.y, look_target.global_position.y + vertical_offset, delta * smoothing)
		self.position.y = target_y
