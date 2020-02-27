extends Node

var chap_1  = load ('res://Chapters/chapter 1/intro vid .tscn')
var chap_2 = load ('res://Chapters/chapter 2/chapter 2.tscn')
var chap_3 = null
var current_scene = null
var current_frame = null
var prev_scene = null
var next_scene = null
var website = null
var gun_sfx = null
#setup auto scene loader and changer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#func _process(delta):
#	pass
