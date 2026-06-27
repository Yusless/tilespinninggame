extends Node
class_name MusicManager

@export var music_day: AudioStreamPlayer
@export var music_night: AudioStreamPlayer

@export var hub_tile: HubTile

var off := false

func _input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("music_off"):
		#off = true
		#music_day.stop()
		#music_night.stop()

func _ready() -> void:
	hub_tile.lighthouse.expedition_finished.connect(_on_lighthosue_expedition_finished)
	hub_tile.lighthouse.expedition_started.connect(_on_lighthosue_expedition_started)
	switch_music(music_night, music_day)
	music_day.play()
	music_night.play()

func switch_music(current_music: AudioStreamPlayer, other_music: AudioStreamPlayer):
	var tween = create_tween()
	other_music.volume_db = -10.0
	tween.set_parallel(true)
	tween.tween_property(current_music, "volume_db", -10.0, 0.4).set_ease(Tween.EASE_IN)
	tween.tween_property(other_music, "volume_db", 0.0, 0.4).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false)
	tween.tween_property(current_music, "volume_db", -80.0, 0.01)
	var tmp = current_music
	current_music = other_music
	other_music = tmp

func _on_lighthosue_expedition_finished():
	switch_music(music_day, music_night)

func _on_lighthosue_expedition_started():
	switch_music(music_night, music_day)
