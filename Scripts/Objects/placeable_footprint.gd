class_name PlaceableFootprint extends Area2D

signal placement_eligibility_changed(eligible: bool)

var allowed_terrain: int = 224
var offending_tiles: int = 0

var placement_eligible: bool = true:
	get:
		return 	placement_eligible
	set(new_value):
		placement_eligible = new_value
		emit_signal("placement_eligibility_changed", new_value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_active(false)

func _process_collision() -> void:
	var colliding_area = !get_overlapping_areas().filter(
		func(area: Area2D):
			return area.get_parent() != get_parent()
	).is_empty()
	
	var colliding_tile = offending_tiles > 0
	placement_eligible = !colliding_area && !colliding_tile

#func _process_tilemap_collision(tilemap: TileMap, body_rid: RID, exited: bool) -> void:
	#var collided_tile_coords = tilemap.get_coords_for_body_rid(body_rid)
	#
	#for index in tilemap.get_layers_count():
		#var tile_data = tilemap.get_cell_tile_data(index, collided_tile_coords)
		#if !tile_data is TileData:
			#continue
		#var terrain_mask = tile_data.get_custom_data_by_layer_id(TerrainDetector.TerrainDataLayers.TERRAIN)
		#if (allowed_terrain & terrain_mask):
			#if exited:
				#offending_tiles -= 1
			#else:
				#offending_tiles += 1
		#break
	#_process_collision()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(statement: bool):
	pass


func _on_area_entered(area: Area2D) -> void:
	_process_collision()
