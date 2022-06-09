tool
extends Polygon2D

### EXPORT ###
# General
export(bool) var bPrintPolygon: bool = false
# Border Line
export(bool) var bBorderVisible: bool = true
export(bool) var bBorderShowBehindParent: bool = true
export(int) var iBorderWidth: int = 4
export(int, 0, 2) var iBorderJointMode: int = 2
export(Color) var cBorderColor: Color = Color.black
export(Texture) var resBorderTexture: Texture = null
export(Gradient) var resBorderGradient: Gradient = null

### INIT ###
func _ready() -> void:
	# Calls
	if not Engine.editor_hint:
		Update_Polygon()

### PROCESS ###
func _process(_delta: float) -> void:
	if Engine.editor_hint: self.call_deferred("Update_Polygon")

### METHODS ###
func Update_Polygon() -> void:
	# Nodepaths
	var _border_line := self.get_node("nBorderLine") as Line2D
	# Border line
	if _border_line != null:
		_border_line.visible = bBorderVisible
		if bBorderVisible:
			_border_line.points = Get_Border_Line_Points(self.polygon)
			_border_line.show_behind_parent = bBorderShowBehindParent
			_border_line.width = iBorderWidth
			_border_line.joint_mode = iBorderJointMode
			_border_line.default_color = cBorderColor
			_border_line.texture = resBorderTexture
			_border_line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
			_border_line.gradient = resBorderGradient
	# General
	if bPrintPolygon:
		Print_Polygon(self.polygon) ; bPrintPolygon = false

### HELPER METHODS ###
static func Get_Border_Line_Points(_polygon_points: PoolVector2Array) -> PoolVector2Array:
	var _points: PoolVector2Array = PoolVector2Array([])
	if _polygon_points.size() >= 3:
		_points = _polygon_points
		var _origin: Vector2 = _points[0]
		var _connector: Vector2 = _origin + (_points[1] - _origin) * 0.5
		_points[0] = _connector
		_points.append(_origin)
		_points.append(_connector)
	return _points

static func Print_Polygon(_polygon_points: PoolVector2Array) -> void:
	var _result: String = "PoolVector2Array(["
	for _point_idx in _polygon_points.size():
		_result += "Vector2" + str(
			_polygon_points[_point_idx]).replace(", ", ".0, ").replace(")", ".0)") + (", " if _point_idx < _polygon_points.size() - 1 else "")
	_result += "])"
	print(_result)
	OS.clipboard = _result
