extends Node2D

@onready var panel_image = $CanvasLayer/Background
@onready var dialogue_label: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var text_frame = $CanvasLayer/TextFrame
@onready var letter_text = $CanvasLayer/LetterText
@onready var fade_rect = $CanvasLayer/ColorRect
@onready var skip_button = $CanvasLayer/SkipButton
@onready var music_player = $MusicPlayer
@onready var knock_player = $KnockPlayer
@onready var door_open_player = $DoorOpenPlayer
@onready var letter_open_player = $LetterOpenPlayer

var bg_frames = [
	preload("res://assets/background/IMG_0951.PNG"),
	preload("res://assets/background/IMG_0952.PNG"),
	preload("res://assets/background/IMG_0953.PNG"),
]
var bg_frame_index := 0
var bg_timer: Timer

var door_closed = preload("res://assets/background/IMG_0955.PNG")
var door_open = preload("res://assets/background/IMG_0956.PNG")
var letter_pickup_img = preload("res://assets/background/IMG_0957.PNG")
var letter_open_img = preload("res://assets/background/IMG_0958.PNG")

var story_texts = [
	"Another Boring Day.... Nothing seems to be happening in my life anymore.",
	"Everyday is the same. Feels like I am stuck in a loop. What's the point of living like this?",
	"I wish something new can happen in my life.",
]
var text_index := 0
var state := "witch"
var is_busy := false

var frame_base_y: float
var label_base_y: float
const SLIDE_OFFSET := 30.0

func _ready() -> void:
	fade_rect.color = Color(0, 0, 0, 1)
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	skip_button.pressed.connect(_end_cutscene)

	dialogue_label.bbcode_enabled = true
	text_frame.texture = preload("res://assets/background/textframe.PNG")
	letter_text.visible = false

	music_player.stream = preload("res://assets/audio/gaana.mp3")
	music_player.play()
	knock_player.stream = preload("res://assets/audio/knock.mp3")
	door_open_player.stream = preload("res://assets/audio/dooropen.mp3")
	letter_open_player.stream = preload("res://assets/audio/letteropening.mp3")

	frame_base_y = text_frame.position.y
	label_base_y = dialogue_label.position.y

	text_frame.modulate.a = 0.0
	dialogue_label.modulate.a = 0.0

	_start_bg_loop()

	await get_tree().create_timer(0.5).timeout
	_fade_in()

	await get_tree().create_timer(5.0).timeout
	await show_text_box()
	await _type_text(_narrator(story_texts[0]))

# --- Text box show/hide with slide + fade ---
func show_text_box() -> void:
	text_frame.position.y = frame_base_y + SLIDE_OFFSET
	dialogue_label.position.y = label_base_y + SLIDE_OFFSET

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(text_frame, "modulate:a", 1.0, 0.4)
	tween.tween_property(text_frame, "position:y", frame_base_y, 0.4)
	tween.tween_property(dialogue_label, "modulate:a", 1.0, 0.4)
	tween.tween_property(dialogue_label, "position:y", label_base_y, 0.4)
	await tween.finished

func hide_text_box() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(text_frame, "modulate:a", 0.0, 0.4)
	tween.tween_property(text_frame, "position:y", frame_base_y + SLIDE_OFFSET, 0.4)
	tween.tween_property(dialogue_label, "modulate:a", 0.0, 0.4)
	tween.tween_property(dialogue_label, "position:y", label_base_y + SLIDE_OFFSET, 0.4)
	await tween.finished

func _narrator(t: String) -> String:
	return "[i][color=#000000]" + t + "[/color][/i]"

func _witch(t: String) -> String:
	return "[color=#7a2ea1]" + t + "[/color]"

func _start_bg_loop() -> void:
	panel_image.texture = bg_frames[0]
	bg_timer = Timer.new()
	add_child(bg_timer)
	bg_timer.wait_time = 0.4
	bg_timer.timeout.connect(_on_bg_frame_tick)
	bg_timer.start()

func _on_bg_frame_tick() -> void:
	bg_frame_index = (bg_frame_index + 1) % bg_frames.size()
	panel_image.texture = bg_frames[bg_frame_index]

func _fade_in() -> void:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.6)

func _input(event: InputEvent) -> void:
	if is_busy:
		return
	if event.is_action_pressed("ui_accept"):
		match state:
			"witch":
				_advance_text()
			"door_wait":
				_start_letter_pickup()
			"pickup_wait":
				_start_letter_opening()
			"letter_wait":
				_end_cutscene()
	elif event.is_action_pressed("ui_cancel"):
		_end_cutscene()

func _type_text(bbcode_text: String) -> void:
	dialogue_label.text = bbcode_text
	dialogue_label.visible_characters = 0
	var total: int = dialogue_label.get_total_character_count()
	for i in range(total + 1):
		dialogue_label.visible_characters = i
		await get_tree().create_timer(0.03).timeout

func _advance_text() -> void:
	is_busy = true
	text_index += 1
	if text_index >= story_texts.size():
		await hide_text_box()
		await get_tree().create_timer(3.0).timeout  # idle beat, no text box
		await _start_door_scene()
		is_busy = false
		return
	await _type_text(_narrator(story_texts[text_index]))
	is_busy = false

func _start_door_scene() -> void:
	is_busy = true
	bg_timer.stop()

	knock_player.play()
	await knock_player.finished

	await show_text_box()
	panel_image.texture = door_closed
	await _type_text(_narrator("A knock at the door..."))

	await get_tree().create_timer(1.0).timeout
	await hide_text_box()

	await get_tree().create_timer(0.5).timeout
	door_open_player.play()
	panel_image.texture = door_open

	await show_text_box()
	await _type_text(_narrator("She opens it, but no one's there..."))
	await get_tree().create_timer(1.0).timeout
	await hide_text_box()

	state = "door_wait"
	is_busy = false

func _start_letter_pickup() -> void:
	is_busy = true
	panel_image.texture = letter_pickup_img
	await show_text_box()
	await _type_text(_witch("Who would leave this for me?"))
	state = "pickup_wait"
	is_busy = false

func _start_letter_opening() -> void:
	is_busy = true
	letter_open_player.play()
	panel_image.texture = letter_open_img
	await _type_text(_narrator("She breaks the seal and unfolds the paper..."))

	await get_tree().create_timer(1.5).timeout
	await hide_text_box()

	letter_text.visible = true
	letter_text.text = "To the Witch Who Doesn't Remember Me,\n\nYou don't know who I am.\n\nBut I know you.\n\nI know you've been waiting for something to break the endless repetition of your days.\n\nSo let me give you something to chase.\n\nDeep in the forest, beyond the old ruins, there is a silver key.\n\nFind it.\n\nBring it back to your home and place it beneath the candle on your table.\n\nWhen you do, you will understand why I came looking for you.\n\nAnd if you still want answers after that...\n\nI'll give you another letter.\n\nSomeone you once knew"

	state = "letter_wait"
	is_busy = false

func _end_cutscene() -> void:
	music_player.stop()
	get_tree().change_scene_to_file("res://game.tscn")
