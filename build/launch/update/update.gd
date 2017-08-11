extends Node2D

var http_domin        = "http://albertlab-huanan.oss-cn-shenzhen.aliyuncs.com"
var http_url          = "/Software/shooter/update/"
var http_version_file = "version.meta" 

var is_inited = false
var cur_down_file_name = ""

func _ready():
	set_process(true)
	
func _process(delta):
	if !is_inited:
		check_version()
		
		var directory = Directory.new()
		if directory.file_exists("res://apps/shooter/data.pck"):
			#_on_launch_pressed()
			print("xxxxxxxxxxxxx")
		

#		if directory.file_exists("user://dlc/update.pck"):
#			print("a")
#		else:
#			download( "http://albertlab-huanan.oss-cn-shenzhen.aliyuncs.com", "/Software/shooter/update/", "update.pck", "user://dlc/update.pck")
		
#		load_dlc()

		is_inited = true

func set_progress_val(value):
	get_node("progress").set_val(value)	
	
func set_text(text):
	get_node("note").set_text(text)
		
func check_version():
	create_dir("user://dlc")
	create_dir("user://download")
	
	var http = preload("res://update/http.gd").new()
	http.connect("loading", self, "_on_loading_version")
	http.connect("loaded", self, "_on_loaded_version")
	http.get(http_domin, http_url+http_version_file, 80, false, "user://download/" + http_version_file)
	
func _on_loading_version(loaded, total):
	var percent = loaded * 5 / total 
	set_progress_val(percent)

func _on_loaded_version(result):
	var directory = Directory.new()
	if !directory.file_exists("user://download/" + http_version_file):
		set_text("check update failed, please check network.")
	else:
		set_progress_val(5)
	
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
	print("haha")
	var result_string = result.get_string_from_ascii()
	cur_down_file_name = ""
	
func create_dir(dir):
	var directory = Directory.new()
	if !directory.file_exists(dir):
		directory.make_dir(dir)
	
func load_dlc():
	Globals.load_resource_pack("user://dlc/update.pck")	

func _on_launch_pressed():
	# 实例化全局脚本
	var global = load("res://global/global.gd").new()
	global.set_name("global")
	get_tree().get_root().add_child(global)
