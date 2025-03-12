extends Polygon2D

const RANGE = 0.05
const NOISE_QUALITY = 250.0
const NOISE_INTENSITY = 0.0088
const OFFSET_INTENSITY = 0.02
const COLOR_OFFSET_INTENSITY = 1.3
var time := 0.0

func _process(delta):
    time += delta
    queue_redraw()

func rand(co: Vector2) -> float:
    return fmod(sin(co.dot(Vector2(12.9898, 78.233))) * 43758.5453, 1.0)

func vertical_bar(pos: float, uv_y: float, offset: float) -> float:
    var edge0 = pos - RANGE
    var edge1 = pos + RANGE
    var x = smoothstep(edge0, pos, uv_y) * offset
    x -= smoothstep(pos, edge1, uv_y) * offset
    return x

func smoothstep(edge0: float, edge1: float, x: float) -> float:
    var t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
    return t * t * (3.0 - 2.0 * t)

func _draw():
    if texture == null:
        return
    
    var uv_offset = Vector2.ZERO
    var width = texture.get_width()
    var height = texture.get_height()
    
    for i in range(0, 71):
        var i_f = i * 0.1313
        var d = fmod(time * -i_f, 1.7)
        var o = sin(1.0 - tan(time * 0.24 * i_f)) * OFFSET_INTENSITY
        uv_offset.x += vertical_bar(d, uv_offset.y, o)
    
    var uv_y = uv_offset.y * NOISE_QUALITY
    uv_y = float(int(uv_y)) * (1.0 / NOISE_QUALITY)
    var noise = rand(Vector2(time * 0.00001, uv_y)) * NOISE_INTENSITY
    uv_offset.x += noise
    
    var offset_r = Vector2(0.006 * sin(time), 0.0) * COLOR_OFFSET_INTENSITY
    var offset_g = Vector2(0.0073 * cos(time * 0.97), 0.0) * COLOR_OFFSET_INTENSITY
    
    var r = texture.get_data().get_pixel((uv_offset + offset_r).x * width, uv_offset.y * height).r
    var g = texture.get_data().get_pixel((uv_offset + offset_g).x * width, uv_offset.y * height).g
    var b = texture.get_data().get_pixel(uv_offset.x * width, uv_offset.y * height).b
    
    draw_colored_polygon(polygon, Color(r, g, b, 1.0))
