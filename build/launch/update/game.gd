extends Node2D

var game_name  = ""
var game_dir = ""
var game_res_dir = ""
var download_dir = ""
var local_meta = null
var remote_meta = null
var http_version_file = "version.meta"
var need_update_pcks = Array()
var download_percent = 0
var is_ready_for_start = false
var auto_start = true
var is_mounted = false
var auto_update = true

func _ready():
	set_process(true)
	
func _process(delta):
	# 启动游戏 
	if is_ready_for_start and auto_start and not is_mounted:
		mount_res()
		is_mounted = true
		
	if is_mounted and is_mount_res_finished():
		start_game()
	
func set_game_name(name):
	game_name = name
	game_dir = "user://apps/" + game_name + "/"
	game_res_dir = "res://apps/" + game_name + "/"
	download_dir = "user://apps/" + game_name + "/download/"
	
	if auto_update:
		_on_launch_pressed()

func _on_launch_pressed():
	if !is_game_exist_in_user_dir():
		# 检测是否自带安装包
		if is_have_installer():
			if install():
				checkupdate()
		else:
			print("Not support yet")	
	else:
		checkupdate()
		
func is_game_exist_in_user_dir():
	var dir = Directory.new()
	if dir.file_exists("user://apps/" + game_name + "/version.meta"):
		return true
	else:
		return false
		
func is_have_installer():
	var dir = Directory.new()
	if dir.file_exists("res://apps/" + game_name + "/version.meta"):
		return true
	else:
		return false
		
func install():
	# clear
	create_dir("user://apps/")
	create_dir(game_dir)
	
	# copy version.meta
	var files = list_files_in_directory(game_res_dir)
	for file in files:
		print(file)
		var dir = Directory.new()
		if dir.copy(game_res_dir + file, game_dir + file) != OK:
			print("copy version.meta failed")
			return false
	
	return true
	
func checkupdate():
	local_meta = load("res://update/version_meta.gd").new()
	local_meta.parse( game_dir + "version.meta")
	
	var http_domain = local_meta.http_domain
	var http_url	= local_meta.http_url
	
	create_dir(download_dir)
	var http = preload("res://update/http.gd").new()
	http.connect("loading", self, "_on_loading_version")
	http.connect("loaded", self, "_on_loaded_version")
	http.get(http_domain, http_url+http_version_file, 80, false, download_dir + http_version_file)
	
func _on_loading_version(loaded, total, file_save_path):
	var percent = min(loaded * 100 / total,60)
	print(percent)
	get_node("progress").set_val(percent)

func _on_loaded_version(result, file_save_path):
	var directory = Directory.new()
	if !directory.file_exists(file_save_path):
		set_text("check update failed, please check network.")
	else:
		remote_meta = load("res://update/version_meta.gd").new()
		remote_meta.parse(download_dir + http_version_file)
		
		for i in range(remote_meta.get_pck_size()):
			var remote_pck = remote_meta.get_pck(i)
			if !local_meta.is_pck_exist(remote_pck.name):
				print("ri")
				need_update_pcks.append(remote_pck)
			else:
				var local_pck = local_meta.get_pck_by_name(remote_pck.name)
				if local_pck.md5 != remote_pck.md5:
					need_update_pcks.append(remote_pck)	
					
		get_node("progress").set_val(100)
	
	if need_update_pcks.size()>0:
		download_pcks()
	else:
		update_progress_val()
		
func is_pck_downloaded(pck):
	var dir = Directory.new()
	if dir.file_exists(download_dir + pck.name):
		return true
	else:
		return false
	
func is_pck_md5_match(pck_name):
	var pck = remote_meta.get_pck_by_name(pck_name)
	var md5 = ""
	var file = File.new()
	md5 = file.get_md5(download_dir + pck_name)
	if md5==pck.md5:
		return true
	else:
		return false	
	
func download_pcks():
	for pck in need_update_pcks:
		if is_pck_downloaded(pck) && is_pck_md5_match(pck.name):
			set_percent(pck.name, 100)
			if download_percent==100:
				copy_from_downloaddir_to_gamedir()
		else:
			down_load_pck(pck.name)		
		
func down_load_pck( pck_name):
	var http = preload("res://update/http.gd").new()
	http.connect("loading", self, "_on_loading_pck")
	http.connect("loaded", self, "_on_loaded_pck")
	
	var http_domain = local_meta.http_domain
	var http_url	= local_meta.http_url
	http.get(http_domain, http_url+pck_name, 80, false, download_dir + pck_name)
	
func _on_loading_pck(loaded, total, file_save_path):
	var percent = min(loaded * 100 / total, 99)
	set_percent(file_save_path, percent)

func _on_loaded_pck(result, file_save_path):
	var directory = Directory.new()
	if !directory.file_exists(file_save_path):
		set_text("check update failed, please check network.")
	else:
		if is_pck_md5_match(file_save_path.get_file()):
			set_percent(file_save_path, 100)
			if download_percent==100:
				copy_from_downloaddir_to_gamedir()
		else:
			# md5 不匹配，删除重新下载
			directory.remove(file_save_path)
			set_percent(file_save_path, 0)
			down_load_pck(file_save_path.get_file())
	
func set_percent( full_name, percent):
	var name = full_name.get_file()
	for pck in need_update_pcks:
		if pck.name==name:
			pck.percent = percent
			
	update_progress_val()
	
func update_progress_val():
	if need_update_pcks.size()==0:
		download_percent = 100
	else:
		var total = need_update_pcks.size() * 100
		var download = 0
		for pck in need_update_pcks:
			download += pck.percent
		
		download_percent = download  * 100 / total
	
	get_node("progress").set_val(download_percent)
	set_text("%d" % download_percent + "%")
	
	if download_percent >=100:
		is_ready_for_start = true
			
func set_text(text):
	get_node("progress/note").set_text(text)
	
func copy_from_downloaddir_to_gamedir():
	var files = list_files_in_directory(download_dir)
	for file in files:
		var dir = Directory.new()
		if dir.copy(download_dir + file, game_dir + file) != OK:
			print("copy data.pck failed")
			
	clear_dir(download_dir)
	clear_nousedpck_in_game_dir()
	
func clear_nousedpck_in_game_dir():
	var version_meta = load("res://update/version_meta.gd").new()
	version_meta.parse( game_dir + "version.meta")	
	var files = list_files_in_directory(game_dir)
	for file in files:
		if file.extension()=="pck":
			if !version_meta.is_pck_exist(file.get_file()):
				var directory = Directory.new()
				directory.remove( game_dir + file)	
	
func clear_dir(dir):
	var files = list_files_in_directory(dir)
	for file in files:
		var directory = Directory.new()
		directory.remove( dir + file)

func create_dir(dir):
	var directory = Directory.new()
	if !directory.file_exists(dir):
		directory.make_dir(dir)
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
	return files

func mount_res():
	# 加载资源
	var version_meta = load("res://update/version_meta.gd").new()
	version_meta.parse( game_dir + "version.meta")	
	for i in range(version_meta.get_pck_size()):
		var pck = version_meta.get_pck(i)
		Globals.load_resource_pack(game_dir + pck.name)
		Globals.reload_settings_binary("res://engine.cfb")
		
func is_mount_res_finished():
	var dir = Directory.new()
	if dir.file_exists("res://launch/launch.tscn"):		
		return true
	else:
		return true

func start_game():
	set_scene("res://launch/launch.tscn")
	
# switch to scene by name
func set_scene(name):
	var curScene = get_tree().get_root().get_child(0)
	
	var sceneRes = ResourceLoader.load(name)
	get_tree().get_root().add_child(sceneRes.instance())
	
	if curScene:
		curScene.queue_free()