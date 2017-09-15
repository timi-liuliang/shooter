extends Node

var t = Thread.new()
var file_save_path = ""

func _init():
	var arg_bytes_loaded = {"name":"bytes_loaded","type":TYPE_INT}
	var arg_bytes_total = {"name":"bytes_total","type":TYPE_INT}
	add_user_signal("loading",[arg_bytes_loaded,arg_bytes_total])
	var arg_result = {"name":"result","type":TYPE_RAW_ARRAY}
	add_user_signal("loaded",[arg_result])
	
func get(domain,url,port,ssl, save_path):
	if(t.is_active()):
		return
	
	file_save_path = save_path
	t.start(self,"_load",{"domain":domain,"url":url,"port":port,"ssl":ssl})
	
func _load(params):
	var err = 0
	var http = HTTPClient.new()
	err = http.connect(params.domain,params.port,params.ssl)
	
	while(http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING):
		http.poll()		
		OS.delay_msec(100)
	 
	var headers = [
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]

	err = http.request(HTTPClient.METHOD_GET,params.url,headers)
	
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		http.poll()
		OS.delay_msec(500)
# 
	var rb = RawArray()
	if(http.has_response()):
		var headers = http.get_response_headers_as_dictionary()
		while(http.get_status()==HTTPClient.STATUS_BODY):
			http.poll()
			var chunk = http.read_response_body_chunk()
			if(chunk.size()==0):
				OS.delay_usec(100)
			else:
				rb = rb+chunk
				call_deferred("_send_loading_signal",rb.size(),http.get_response_body_length()) 	
				
	call_deferred("_send_loaded_signal")
	http.close()
	
	var cur_down_file = File.new()
	cur_down_file.open(file_save_path, File.WRITE)
	cur_down_file.store_buffer(rb)
	cur_down_file.close()
	
	return rb	
	
func _send_loading_signal(l,t):
	emit_signal("loading",l,t, file_save_path)

func _send_loaded_signal():
	var r = t.wait_to_finish()
	emit_signal("loaded",r, file_save_path)