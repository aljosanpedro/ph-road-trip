extends Control

#region Initialized Variables and Exports
@onready var camera = $Camera2D
@onready var camera_overlay = $CameraLayer
@onready var camera_gallery = $GalleryMenu
@onready var camera_shutter = $CameraLayer/CameraShutter

# Technically, negative to because LEFT/TOP siya na limits. But it's here as an
# absolute value.
const NL_X: int = 371
const NL_Y: int = 94
const SL_X: int = 1514 
const SL_Y: int = 825 
#endregion

#region Virtual functions
func _ready() -> void:
	Events.open_camera_signal.connect(_camera_activate)

func _process(_delta: float) -> void:
	#print(get_viewport().get_mouse_position())
	if camera.enabled: camera.position = get_viewport().get_mouse_position()

	
func _input(_event: InputEvent) -> void:
	# DEPRECATED CAMERA ACTION: Open camera via CAMERA COMMAND
	#if Input.is_action_just_pressed("ui_accept"):
		#if camera.enabled: _camera_disable()
		#else: _camera_activate()
	
	## DEPRECATED GALLERY ACTION: Open Gallery via Mouse Thumb 1
	## ONLY ALLOWED IN DEBUG
	if Input.is_action_just_pressed("open_gallery") and OS.is_debug_build():
		if camera_gallery.visible: camera_gallery.visible = false
		else: camera_gallery.visible = true
		
	# INFO CAMERA ACTION: Play captures a photo via RIGHT CLICK.
	if Input.is_action_just_pressed("camera_capture") and camera.enabled:
		camera_shutter.hide()
		await camera_gallery.capture_photo()
		camera_shutter.show()
		_camera_disable()
	
	# CAMERA ACTION: Zooming in via MOUSE UP/DOWN
	if camera.enabled:
		camera.zoom.x = clampf(camera.zoom.x - (Input.get_axis("zoom_out", "zoom_in") * 0.1), 0.75, 2.0)
		camera.zoom.y = clampf(camera.zoom.y - (Input.get_axis("zoom_out", "zoom_in") * 0.1), 0.75, 2.0)
		_camera_recalculate_limit()
#endregion

#region Custom functions
func _camera_activate() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	camera_overlay.visible = true
	camera.enabled = true

func _camera_disable() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	camera_overlay.visible = false
	camera.enabled = false

## Function that recalculates the limits of a camera, especially when it is
## zooming in/out.
## Right: 1333 px when zoomed
## Bottom: 773 px when zoomed
func _camera_recalculate_limit() -> void:
	var new_left_limit 		= -(NL_X * (1.0 / camera.zoom.x))
	var new_top_limit 		= -(NL_Y * (1.0 / camera.zoom.y))
	var new_right_limit 	= SL_X - ((NL_X + 12) * (1.0 - (1.0 / camera.zoom.x)))
	var new_bottom_limit 	= SL_Y - ((NL_Y + 12) * (1.0 - (1.0 / camera.zoom.y)))
	camera.set_limit(SIDE_LEFT, new_left_limit)
	camera.set_limit(SIDE_TOP, new_top_limit)
	camera.set_limit(SIDE_RIGHT, new_right_limit)
	camera.set_limit(SIDE_BOTTOM, new_bottom_limit)
	#print("LR: ", 1.0 - (1.0 / camera.zoom.x))
	#print("Camera Right: ", camera.limit_right, " ", camera.zoom.x - 1)
	#print("Camera Bottom: ", camera.limit_bottom, " ", camera.zoom.y - 1)
#endregion
