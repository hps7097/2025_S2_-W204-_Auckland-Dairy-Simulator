# MADE WITH CHATGPT
extends "res://addons/gut/test.gd"

func test_good_ending_condition():
	var em = EndingManager.new()
	em.current_choices = [
		{"id": "a", "params": {"weight": 3}},
		{"id": "b", "params": {"weight": 3}}
	]
	assert_eq(em.determine_ending(), "good")

func test_bad_ending_condition():
	var em = EndingManager.new()
	em.current_choices = [
		{"id": "a", "params": {"weight": -3}},
		{"id": "b", "params": {"weight": -3}}
	]
	assert_eq(em.determine_ending(), "bad")

