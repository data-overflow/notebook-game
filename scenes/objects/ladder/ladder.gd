extends TextureRect

func _ready():
	var hitbox = $Area/Hitbox
	hitbox.position.y = margin_bottom / 2
	hitbox.shape.extents.y =  margin_bottom / 2
	$Area.add_to_group("ladder")
