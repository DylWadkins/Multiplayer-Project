# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: MIT

@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("Destructible", "Node3D", preload("res://addons/destruction/destruction.gd"), preload("res://addons/destruction/destruction_icon.svg"))
	
func _exit_tree() -> void:
	remove_custom_type("Destructible")
