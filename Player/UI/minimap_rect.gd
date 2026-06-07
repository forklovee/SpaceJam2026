extends TextureRect

func _process(delta: float) -> void:
	pass
	#self.visible=Input.is_key_pressed(KEY_M)
	#if self.texture==null:
		#if Game.level.view!=null:
			#var sv:SubViewport=Game.level.view
			#self.texture=sv.get_texture()
			#sv.render_target_update_mode=sv.UPDATE_ALWAYS
