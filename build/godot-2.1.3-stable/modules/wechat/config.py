def can_build(plat):
	return True
	
def configure(env):
	#env.disable_module()
	if env['platform'] == "iphone":
		env.Append(LIBPATH=['#modules/wechat/ios/lib'])
		env.Append(LIBS=['WeChatSDK', 'sqlite3.0'])
		env.Append(LINKFLAGS=['-Objc -all_load', '-framework', 'CFNetwork'])

