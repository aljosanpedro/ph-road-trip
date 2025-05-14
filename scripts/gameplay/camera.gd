extends Control

#region Initialized Variables and Exports
@onready var camera = $Camera2D
@onready var camera_overlay = $CameraLayer
@onready var camera_gallery = $GalleryMenu
@onready var camera_shutter = $CameraLayer/CameraShutter

# Technically, negative to because LEFT/TOP siya na limits. But it's here as an
# absolute value.
const NL_X: int = 654
const NL_Y: int = 141
const SL_X: int = 666 
const SL_Y: int = 339
#endregion

#region Virtual functions
func _ready() -> void:
	Events.open_camera_signal.connect(_camera_activate)

func _process(_delta: float) -> void:
	#print(get_viewport().get_mouse_position())
	if camera.enabled: camera.position = get_viewport().get_mouse_position()

func _input(_event: InputEvent) -> void:
	# DEPRECATED CAMERA ACTION: Open camera via CAMERA COMMAND
	## ONLY ALLOWED IN DEBUG
	#if Input.is_action_just_pressed("ui_accept"):
		#if camera.enabled: _camera_disable()
		#else: _camera_activate()
	
	## DEPRECATED GALLERY ACTION: Open Gallery via Mouse Thumb 1
	## ONLY ALLOWED IN DEBUG
	#if Input.is_action_just_pressed("open_gallery") and OS.is_debug_build():
		#if camera_gallery.visible: camera_gallery.visible = false
		#else: camera_gallery.visible = true
		
	# INFO CAMERA ACTION: Play captures a photo via RIGHT CLICK.
	if Input.is_action_just_pressed("camera_capture") and camera.enabled:
		_camera_take_photo()
		_camera_disable()
	
	# CAMERA ACTION: Zooming in via MOUSE UP/DOWN
	if camera.enabled:
		camera.zoom.x = clampf(camera.zoom.x - (Input.get_axis("zoom_out", "zoom_in") * 0.1), 0.75, 2.0)
		camera.zoom.y = clampf(camera.zoom.y - (Input.get_axis("zoom_out", "zoom_in") * 0.1), 0.75, 2.0)
		_camera_recalculate_limit()
#endregion

#region Custom functions
func _camera_take_photo() -> void:
	#camera_shutter.hide()
	camera_overlay.hide()
	await camera_gallery.capture_photo()
	
	# Once photo taken, tell Events.
	Events.camera_photo_taken.emit()

func _camera_activate() -> void:
	Events.show_item_outline(false) # Hide item outlines for picture taking.
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	camera_overlay.show()
	camera.enabled = true

func _camera_disable() -> void:
	Events.show_item_outline(true) # Show item outlines for navigation.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	camera_overlay.hide()
	camera.enabled = false

## Function that recalculates the limits of a camera, especially when it is
## zooming in/out.
## Right: 1333 px when zoomed
## Bottom: 773 px when zoomed
# Get 
func _camera_recalculate_limit() -> void:
	var new_left_limit 		= -(NL_X * (1.0 / camera.zoom.x))
	var new_top_limit 		= -(NL_Y * (1.0 / camera.zoom.y))
	
	# INFO: Multiplicative inverse, motherfuckers.
	var new_right_limit 	= 1920 + (SL_X * (1.0 / camera.zoom.x)) 
	var new_bottom_limit 	= 1080 + (SL_Y * (1.0 / camera.zoom.y)) 
	
	camera.set_limit(SIDE_LEFT, new_left_limit)
	camera.set_limit(SIDE_TOP, new_top_limit)
	camera.set_limit(SIDE_RIGHT, new_right_limit)
	camera.set_limit(SIDE_BOTTOM, new_bottom_limit)
	print("Current Zoom: ", camera.zoom.x)
	print("Camera Right: ", camera.limit_right, " ", camera.zoom.x - 1)
	print("Camera Bottom: ", camera.limit_bottom, " ", (1.0 / camera.zoom.y))


	
#endregion
