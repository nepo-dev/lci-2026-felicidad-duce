
extends ColorRect

var scratch_texture: DrawableTexture2D

#Holaaaa ahora usamos un png para el pincel!! 
var brush_texture: Texture2D = preload("res://TestDrawingMinigame/Brush.png")

var brush_material: ShaderMaterial


var is_scratching := false


var brush_size := 35


var total_pixels := 0
var erased_pixels := 0

var grid_size := 10


var erased_grid := []
var last_position := Vector2.ZERO


func _ready():

	scratch_texture = DrawableTexture2D.new()

	scratch_texture.setup(
		int(size.x),
		int(size.y),
		DrawableTexture2D.DRAWABLE_FORMAT_RGBA8,
		Color.WHITE
	)


	brush_material = ShaderMaterial.new()
	brush_material.shader = preload("res://TestDrawingMinigame/brush.gdshader")
#Shader de el pincel para borrar

	material.set_shader_parameter("mask_texture", scratch_texture)


	total_pixels = 0

	for x in range(0, int(size.x), grid_size):
		for y in range(0, int(size.y), grid_size):
			total_pixels += 1
			erased_grid.append(false)



func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_scratching = event.pressed

			if is_scratching:
				last_position = get_local_mouse_position()
				erase_at(last_position)

	#Logica mouse

	if event is InputEventMouseMotion and is_scratching:
		var current_position = get_local_mouse_position()

		erase_line(last_position, current_position)
		last_position = current_position


func erase_line(from: Vector2, to: Vector2):

	var distance = from.distance_to(to)
	var steps = int(distance / 5.0) + 1

	for i in range(steps):
		var point = from.lerp(to, float(i) / steps)
		erase_at(point)


func erase_at(pos: Vector2):

	var rect = Rect2i(
		int(pos.x) - brush_size,
		int(pos.y) - brush_size,
		brush_size * 2 + 1,
		brush_size * 2 + 1
	)

	scratch_texture.blit_rect(
		rect,
		brush_texture,
		Color.WHITE,
		0,
		brush_material
	)


	#con esto rollo solo calculamos donde empieza y termina el area del pincel
	var columns = ceili(size.x / float(grid_size))
	var rows = ceili(size.y / float(grid_size))

	var start_x = max(0, int(floor((pos.x - brush_size) / grid_size)))
	var end_x = min(columns, int(floor((pos.x + brush_size) / grid_size)) + 1)

	var start_y = max(0, int(floor((pos.y - brush_size) / grid_size)))
	var end_y = min(rows, int(floor((pos.y + brush_size) / grid_size)) + 1)

	for x in range(start_x, end_x):
		for y in range(start_y, end_y):

			var grid_index = x * rows + y

			if not erased_grid[grid_index]:

				var point = Vector2(x * grid_size, y * grid_size)

				if point.distance_to(pos) <= brush_size:

					erased_grid[grid_index] = true
					erased_pixels += 1


	var percentage = float(erased_pixels) / total_pixels * 100.0

	if percentage >= 80.0:
		print("Dibujo borrado al 80%!!!!!!!!!!! hecho next.")
