extends Node3D

@export var gameTime : float = 60
@export var gameTimeForOneMerge : float = 6
@onready var ui_manager = %UIManager
@onready var drag_manager = %DragManager

enum GameState {
	Playing,
	GameOver,
	Win
}
var gameState : GameState = GameState.Playing

func _process(delta):
	if gameState != GameState.Playing:
		return
	gameTime -= delta
	if gameTime <= 0:
		GameOver()


func ChangeGameState(state : GameState):
	gameState = state

func GameOver():
	ChangeGameState(GameState.GameOver)
	ui_manager.OnGameOver()
	drag_manager.canMove = false

func LevelCompleted():
	await get_tree().create_timer(1.0).timeout
	ChangeGameState(GameState.Win)
	ui_manager.OnLevelCompleted()
	drag_manager.canMove = false

func SetGameTime(time):
	gameTime = time
