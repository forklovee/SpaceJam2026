class_name Level extends Node3D

signal crystal_amount_changed(level: Level)

@onready var query_plane: SpacePlane = $Space_BG
@onready var enemyRespawn: EnemyRespawn = $EnemyBase/EnemyRespawn
@onready var view: SubViewport = $SubViewport

@export var player_base: Base
@export var enemy_base: Base

var crystals_to_gather: Array = []

# Crystal and ships that are targetting it
var crystal_to_enemies_blackboard: Dictionary[Crystal, Array] = {}
var enemy_to_crystal_blackboard: Dictionary[Ship, Crystal] = {}

func _ready() -> void:
	crystals_to_gather = get_tree().get_nodes_in_group(&"Crystal")
	for crystal in crystals_to_gather:
		crystal = crystal as Crystal
		crystal.gathered.connect(_on_crystal_gathered.bind(crystal))
	
	print(self, " registered ", crystals_to_gather.size(), " crystals.")
	
	for enemy in get_tree().get_nodes_in_group(&"EnemyShip"):
		enemy = enemy as EnemyShip
		enemy.ai_controller.target_crystal = register_target_crystal(enemy)

func get_player_spawn_transform() -> Transform3D:
	if player_base:
		return Transform3D(
			player_base.spawnpoint.global_basis,
			player_base.spawnpoint.global_position*Vector3(1.0, 0.0, 1.0)
		)
	printerr(self, " no player base set!")
	return Transform3D.IDENTITY
		

func _on_crystal_gathered(_ship, crystal: Crystal):
	if crystal in crystals_to_gather:
		crystals_to_gather.erase(crystal)
		crystal_amount_changed.emit(self)


func register_target_crystal(ship: Ship) -> Crystal:
	for crystal in crystals_to_gather:
		if !is_instance_valid(crystal):
			continue
		if crystal_to_enemies_blackboard.has(crystal):
			continue
		crystal = crystal as Crystal
		crystal.tree_exiting.connect(_on_crystal_destroyed.bind(crystal))
		ship.tree_exiting.connect(_on_ship_destroyed.bind(ship))
		
		crystal_to_enemies_blackboard[crystal] = [ship]
		enemy_to_crystal_blackboard[ship] = crystal
		
		return crystal
	
	# sort crystals by least targeted asc
	var keys = crystal_to_enemies_blackboard.keys()
	if keys.is_empty(): # no crystals left
		return null
	
	keys.sort_custom(
		func(a: Crystal, b: Crystal):
			return crystal_to_enemies_blackboard[a].size() < crystal_to_enemies_blackboard[b].size()
	)
	
	var first_crystal: Crystal = keys[0]
	if !ship.tree_exiting.is_connected(_on_ship_destroyed):
		ship.tree_exiting.connect(_on_ship_destroyed.bind(ship))
	crystal_to_enemies_blackboard[first_crystal].append(ship)
	
	return first_crystal

func _on_crystal_destroyed(crystal: Crystal):
	if !crystal_to_enemies_blackboard.has(crystal):
		return
	
	crystals_to_gather.erase(crystal)
	
	# get ships that are targetting the crystal
	var ships_to_crystal := crystal_to_enemies_blackboard[crystal]
	for ship in ships_to_crystal:
		enemy_to_crystal_blackboard.erase(ship)
	crystal_to_enemies_blackboard.erase(crystal)

func _on_ship_destroyed(ship: Ship):
	if !enemy_to_crystal_blackboard.has(ship):
		return
	
	var crystal := enemy_to_crystal_blackboard[ship]
	enemy_to_crystal_blackboard.erase(ship)
	crystal_to_enemies_blackboard[crystal].erase(ship)
