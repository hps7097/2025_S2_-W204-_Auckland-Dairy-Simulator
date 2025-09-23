# MADE WITH CHATGPT
extends GutTest

func test_add_upgrade():
	GameState.reset()
	GameState.add_upgrade("fast_scanner")
	assert_true(GameState.has_upgrade("fast_scanner"))
