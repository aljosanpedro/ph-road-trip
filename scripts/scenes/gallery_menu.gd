extends CanvasLayer

@onready var gallery_container = $ImageContainer

#var pictures: Array = [
	#
#]


func capture_photo() -> void:
	if len(Events.scrapbook_pictures) == 7: # Locations/Pictures
		return 
	
	# TODO: Crop image https://forum.godotengine.org/t/how-to-crop-center-of-an-image/5828/2
	await RenderingServer.frame_post_draw
	var new_image: Image = get_viewport().get_texture().get_image()
	new_image.resize(1152, 648)
	
	# Crop image by making a new image that mip maps it to OBLIVION.
	# To anyone going to maintain this, I can assure you that IT IS NOT WORTH IT to comprehend blit_rect.
	# TODO: Adjust ratio appropriately. SCRATCH THAT, RESIZE EXISTS.
	
	var cropped_image: Image = Image.new()
	var specified_region = Rect2(371, 95, 417, 376)
	cropped_image = Image.create(417, 376, true, new_image.get_format())
	cropped_image.blit_rect(new_image, specified_region, Vector2(0,0))
	
	# Append image to the array and then call pictures.
	#pictures.append(cropped_image)
	_create_new_image(cropped_image)

func _create_new_image(new_image: Image) -> void:
	# Create a new TextureRect and use new image taken.
	var new_entry = TextureRect.new()
	new_entry.texture = ImageTexture.create_from_image(new_image)
	
	# Set it so that the gallery works like a charm. AND NOT TAKE THE ENTIRE SPACE.
	new_entry.custom_minimum_size = Vector2(200, 181)
	new_entry.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	
	new_entry.scale = Vector2(0.18, 0.17)
	new_entry.position.x += 1.9
	new_entry.position.y += 1.5
	
	# Finally, add it to gallery.
	# Deprecated; and will queue_free() new_entry
		# preventing adding to Events.scrapbook_photos
	#gallery_container.add_child(new_entry)
	
	Events.scrapbook_pictures.append(new_entry)
