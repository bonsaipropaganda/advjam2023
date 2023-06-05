extends Resource

class_name WeaponRes	# Weapon Resource

@export var single_damage: int = 1	# Damage dealt to a single enemy, occurs when the qte is failed
@export var group_damage: int = 1	# Damage dealt to multiple enemies, occurs when qte succeeds
