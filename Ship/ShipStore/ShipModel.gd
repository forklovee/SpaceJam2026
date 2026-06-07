extends Resource
class_name ShipModel


@export var BaseMass:float=1.0
@export var BaseStorage:int=10
@export var BaseHealth:int=100
@export var BaseShield:int=100
@export var BaseFuel:float=100.0

@export var BrandName:String="New Ship"
@export var view3D:PackedScene=null

@export var upgrades:Array[ShipModelUpgrade]=[]

@export var extraWeaponIDs=[0,1]
@export var extraWeaponNames=["LASERS","ROCKETS"]
@export var upgrade_slots=2
@export var marketing_text=""
