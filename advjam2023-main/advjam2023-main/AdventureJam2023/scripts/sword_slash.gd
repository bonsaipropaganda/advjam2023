extends Area2D


func _on_animation_animation_looped():  #after a loop, stop the animation
	$Animation.stop()
	set_visible(false)
	position = Vector2(-1000, -1000)  #move the sword slash to the edge of the map.


# attack nearest enemy, this is triggered when qte fails
func attack_nearest(damage):
	# the variable containing nearest enemy to the attack direction
	var nearest_attackable = null
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			# if nearest_attackable is not assigned yet, or the current body is closer to the player than the nearest_attackable
			if (
				nearest_attackable == null
				or (
					body.position.distance_to(position)
					< nearest_attackable.position.distance_to(position)
				)
			):
				# set the nearest_attackable to the current body
				nearest_attackable = body
	if nearest_attackable != null:
		nearest_attackable.take_damage(damage)


# attack all enemy in the area, this is triggered when qte success
func attack_all(damage):
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(damage)
