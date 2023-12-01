extends Control

@onready var game_manager = %GameManager
@onready var merge_platform = %MergePlatform

@onready var in_game_panel = $InGame_Panel
@onready var button_restart = $InGame_Panel/Button_Restart
@onready var timer_text = $InGame_Panel/Timer_Panel/Timer_Text
@onready var star_icon = $InGame_Panel/Star_Panel/Star_Icon
@onready var star_text = $InGame_Panel/Star_Panel/Star_Text
var starIcon : PackedScene = preload("res://resources/other/star_icon.tscn")

@onready var fail_panel = $Fail_Panel
@onready var game_over_text = $Fail_Panel/GameOver_Text
@onready var animation_player = $Fail_Panel/GameOver_Text/AnimationPlayer

@onready var win_panel = $Win_Panel
@onready var star_text_win = $Win_Panel/Star_Panel/Star_Text

var starCount : int

# Called when the node enters the scene tree for the first time.
func _ready():
	in_game_panel.show()
	win_panel.hide()
	fail_panel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gameTime = game_manager.gameTime
	UpdateTimerText(int(gameTime))

func UpdateTimerText(time):
	timer_text.text = formatTime(time)

func IncreaseStarText(star):
	starCount += star
	var spawnedStar = starIcon.instantiate()
	add_child(spawnedStar)
	var camera = get_tree().root.get_camera_3d()
	var screenPos = camera.unproject_position(merge_platform.global_position)
	spawnedStar.global_position = screenPos
	var tween = create_tween()
	tween.tween_property(spawnedStar, "position", star_icon.position, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	var onTweenEnd = func OnTweenEnd():
		star_text.text = str(starCount)
		spawnedStar.queue_free()
	tween.tween_callback(onTweenEnd)

func _on_button_restart_pressed():
	RestartScene()

func RestartScene():
	get_tree().reload_current_scene()

func formatTime(seconds : int) -> String:
	var minutes = seconds / 60
	minutes %= 60
	seconds %= 60

	return "%0*d:%0*d" % [2, minutes, 2, seconds]
	
func OnGameOver():
	in_game_panel.hide()
	win_panel.hide()
	fail_panel.show()
	animation_player.play("gameOverText_Scale")

func OnLevelCompleted():
	in_game_panel.hide()
	win_panel.show()
	fail_panel.hide()
	star_text_win.text = str(starCount)
