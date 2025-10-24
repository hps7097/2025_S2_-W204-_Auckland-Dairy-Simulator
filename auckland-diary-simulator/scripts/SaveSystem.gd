# FIXED BY CHATGPT
extends Node
class_name SaveSystem

const DEFAULT_NAME := "autosave"

func save_game(save_name: String = DEFAULT_NAME) -> bool:
    return GameState.save_to_file(save_name)

func load_game(save_name: String = DEFAULT_NAME) -> bool:
    return GameState.load_from_file(save_name)

func list_saves() -> Array:
    return GameState.list_saves()


