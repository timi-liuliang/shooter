extends Node2D

var cur_down_file_name = ""

func _ready():
	print(OS.get_data_dir())
	var directory = Directory.new()
	if directory.file_exists("user://dlc/update.pck"):
		print("a")
	else:
		create_dir("user://dlc")
		download( "http://albertlab-huanan.oss-cn-shenzhen.aliyuncs.com", "/Software/shooter/update/", "update.pck", "user://dlc/update.pck")
		
	#load_dlc()
	
func download( domin, url, file_name, save_path):
	cur_down_file_name = file_name
	var http = preload("res://update/http.gd").new()
	http.connect("loading", self, "_on_loading")
	http.connect("loaded", self, "_on_loaded")
	http.get(domin, url+file_name, 80, false, "user://dlc/" + file_name)
	
func _on_loading(loaded, total):
	var percent = loaded * 100 / total
	print(percent)
	
func _on_loaded(result):
	var result_string = result.get_string_from_ascii()
	cur_down_file_name = ""
	
func create_dir(dir):
	var directory = Directory.new()
	if !directory.file_exists(dir):
		directory.make_dir(dir)
	
func load_dlc():
	Globals.load_resource_pack("user://dlc/update.pck")	

func _on_Button_pressed():
	# 实例化全局脚本
	var global = preload("res://global/global.gd").new()
	global.set_name("global")
	get_tree().get_root().add_child(global)
