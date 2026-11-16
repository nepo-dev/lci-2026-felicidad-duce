
extends ColorRect

var scratch_image: Image
#Imagen blanca que vamos a modificar
var scratch_texture: ImageTexture
#versionde la imagen q godot muestra
var is_scratching := false
#boton izquierdo si esta manteniendo


var brush_size := 35
#tamamno brush
var total_pixels := 0
var erased_pixels := 0
#Cuantos pixeles borrados
#Pixeles del rectangulo
var last_position := Vector2.ZERO
#Ultima posicion raton
func _ready():
	scratch_image = Image.create(
		size.x,
		size.y,
		false,
		Image.FORMAT_RGBA8
	)
#Creamos una imagen nueva al empezar el juego
#False s para mipmaps
#RGBA porque es el canal con alpah para modificar tranparencia
	scratch_image.fill(Color.WHITE)
#Rellenamos toda la imagen de blanco,creamos la superficie que vamos a "Rascar"
	scratch_texture = ImageTexture.create_from_image(
		scratch_image
	)

#La peor parte, creamos un shader. El shader mira la textura que hemos creado, comprueba el canal de alpha de cada uno de los pixeles
#dibuja blanco donde el alpha sea 1,dibuja transparencia donde el alpha sea 0
#En la parte de color los cuatro valores representan rojo verde azul y alpha por lo tanto siempre dibujamos en blanco peros u transparencia depende de la imagen
	material.set_shader_parameter("mask_texture", scratch_texture)

	total_pixels = int(size.x * size.y)


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
#Guardamos posicion actual y dibujamos una linea netre la posicion actual y la anterior
#Asihacemos que no hayan pequenos espacion sin borrar de un movimiento a lotro

func erase_line(from: Vector2, to: Vector2):
	var distance = from.distance_to(to)
	var steps = int(distance / 5.0) + 1

	for i in range(steps):
		var point = from.lerp(to, float(i) / steps)
		erase_at(point)
#donde estaba el raton antes . donde esta el raton ahora.
#Calculamos cuantos puntos necesitamos para rellenar el especia 
#usamos lerp para calucalr posiciones intermedias entre los dos puntos y asi hacemos un rascado que sea continuo


func erase_at(pos: Vector2):
	var radius = brush_size
#La funcion mas importante, recibimos una posicion y establecemos el radio del pincel(Radio del pincel esta puesta arriba)
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
#Creamos dos bucles, uno recorre los pixeles horizontalmente y otro verticalmente, basicamente creamos un cuadrado alrededor del raton
#ESto no mola mucho porque queremos un cuadrado asi qeu hacemos esto
#
			if Vector2(x, y).length() > radius:
				continue
#Esto calcula la distancia entre el centro del pincel y cada pixel
#Si esta fuera del radio lo ignoramos.
			var px = int(pos.x) + x
			var py = int(pos.y) + y
#Comprobamos que no estamso intentando borrar fuera del rectangulo
			if px < 0 or py < 0:
				continue

			if px >= size.x or py >= size.y:
				continue

			if scratch_image.get_pixel(px, py).a > 0:
				scratch_image.set_pixel(
					px, py, Color.TRANSPARENT
				)
				erased_pixels += 1
#Tres cosas, comprobamos si el pixel es visible, si lo es convertimos en transparente
#Sumamos un al contandor de pixeles borrados
	scratch_texture.update(scratch_image)

	var percentage = float(erased_pixels) / total_pixels * 100.0
	#Porcentaje es igual a la division entre pixeles borrados y pixeles totales multiplicado entre 100

	if percentage >= 80.0:
		print("Dibujo borrado al 80%!!!!!!!!!!! hecho next.")
