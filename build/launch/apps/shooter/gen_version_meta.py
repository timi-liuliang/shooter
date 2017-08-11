import os
import shutil
import json
import hashlib

http_domain = "http://albertlab-huanan.oss-cn-shenzhen.aliyuncs.com"
http_url    = "/Software/shooter/update/"

def md5( dir, file):
    fname = dir + file
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

print("generate version meta begin")
root_path = os.getcwd() + '/'
version_file_name = root_path + "version.meta"
version_file = open(version_file_name, "w+")
version_file.writelines("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
version_file.writelines("<pcks domain=\"%s\" url=\"%s\">\n" % (http_domain, http_url))

def gen_version_info( file):
    md5_str = md5(root_path, file)
    print("generate verison info for file [%s] md5 [%s]" % (file, md5_str))
    version_file.writelines("\t<pck name=\"%s\" md5=\"%s\" />\n" % (file, md5_str))

dirs = os.listdir(root_path)
dirs.sort()
for file in dirs:
    if os.path.splitext(file)[1] == '.pck':
        gen_version_info( file)

version_file.writelines("</pcks>")
version_file.close()

print("generate version meta end")

