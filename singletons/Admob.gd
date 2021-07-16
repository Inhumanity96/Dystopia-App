extends Node

class_name Admob

var enabled
var banner_id = ''
var is_real

var banner_on_top
var banner_size

func init():
	print ('initialiazing admob')

func is_real_set(new_val) -> void:
	is_real = new_val

func load_banner():
	print ('loading banner')
func show_banner():
	print('show admob banner')

func hide_banner():
	print('hide admob banner')
