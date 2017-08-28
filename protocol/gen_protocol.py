import os
import shutil
import json

root_path = os.getcwd() + '/'
java_save_path = root_path + "../server/src/protocol/"
gd_save_path   = root_path + "../client/global/protocol/"

# recreate java file save path
if os.path.exists(java_save_path):
    shutil.rmtree(java_save_path)

os.mkdir(java_save_path)

if os.path.exists(gd_save_path):
    shutil.rmtree(gd_save_path)

os.mkdir(gd_save_path)

def gen_protocol_java( file, id):
    protocol_name = os.path.splitext(file)[0]

    java_file_name = java_save_path + protocol_name + ".java"
    print("prepare generate " + java_file_name)
    java_file = open(java_file_name, "w+")
    java_file.writelines("package protocol;\n\n")
    java_file.writelines("import io.netty.buffer.ByteBuf;\n")
    java_file.writelines("import io.netty.buffer.Unpooled;\n\n")
    java_file.writelines("public class " + protocol_name + " extends message {\n\n")

    data_file = open(file)
    data = json.load(data_file) 
    for key in data.keys():
        if data[key]=='string':
            java_file.writelines("\tpublic String " + key + " = \"\";\n")
        else:
            java_file.writelines("\tpublic " + data[key] +" " + key + " = 0;\n")

    # get_id
    java_file.writelines("\t@Override\n")
    java_file.writelines("\n")
    java_file.writelines("\tpublic int id(){\n")
    java_file.writelines("\t\t return %d;\n" % id)
    java_file.writelines("\t}\n")

    # get_size
    length = 0
    strings = ''
    for key in data.keys():
        if data[key]=='int':
            length += 4
        if data[key]=='long':
            length += 8
        if data[key]=='float':
            length += 4
        if data[key]=='string':
            length += 4
            strings += "+" + key + ".length()" 

    java_file.writelines("\n")
    java_file.writelines("\t@Override\n")
    java_file.writelines("\tpublic int length(){\n")
    java_file.writelines("\t\t return %d %s;\n" % (length, strings))
    java_file.writelines("\t}\n")

    # data
    java_file.writelines("\n")
    java_file.writelines("\tpublic ByteBuf data(){\n")
    java_file.writelines("\t\tByteBuf byteBuffer = Unpooled.buffer(8+length());\n")
    java_file.writelines("\t\tbyteBuffer.writeInt(id());\n")
    java_file.writelines("\t\tbyteBuffer.writeInt(length());\n")
    for key in data.keys():
        if data[key]=='int':
            java_file.writelines("\t\tbyteBuffer.writeInt(%s);\n" % key)
        if data[key]=='long':
            java_file.writelines("\t\tbyteBuffer.writeLong(%s);\n" % key)
        if data[key]=='float':
            java_file.writelines("\t\tbyteBuffer.writeFloat(%s);\n" % key)
        if data[key]=='string':
            java_file.writelines("\t\twrite_string(byteBuffer, %s);\n" % key)

    java_file.writelines("\t\tbyteBuffer.writeByte(64);\n")
    java_file.writelines("\t\tbyteBuffer.writeByte(64);\n")
    java_file.writelines("\t\treturn byteBuffer;\n")
    java_file.writelines("\t}\n")

    # parse_data
    java_file.writelines("\n")
    java_file.writelines("\t@Override\n")
    java_file.writelines("\tpublic void parse_data(ByteBuf byteBuffer){\n")
    for key in data.keys():
        if data[key]=='int':
            java_file.writelines("\t\t%s = byteBuffer.readInt();\n" % key)
        if data[key]=='long':
             java_file.writelines("\t\t%s = byteBuffer.readLong();\n" % key)
        if data[key]=='float':
            java_file.writelines("\t\t%s = byteBuffer.readFloat();\n" % key)
        if data[key]=='string':
            java_file.writelines("\t\t%s = read_string(byteBuffer);\n" % key)
    
    java_file.writelines("\t}\n")

    # end
    java_file.writelines("}\n")
    java_file.close()

    print("generate " + java_file_name + " succeed")
    data_file.close()


def gen_protocol_godot(file, id):
    protocol_name = os.path.splitext(file)[0]

    gd_file_name = gd_save_path + protocol_name + ".pb.gd"
    print("prepare generate [" + gd_file_name + "]")
    gd_file = open( gd_file_name, "w+")
    gd_file.writelines("extends Node\n\n")

    with open(file) as data_file:
        data = json.load(data_file) 
        for key in data.keys():
            if data[key] == 'string':
                gd_file.writelines("var " + key + " = String("")\n")
            elif data[key] == 'long':
                gd_file.writelines("var " + key + " = -1\n")
            else:
                gd_file.writelines("var " + key + " = " + data[key] +"(0)\n")

    gd_file.writelines("\n")
    gd_file.writelines("func _ready():\n")
    gd_file.writelines("\tpass\n\n")

    # name
    gd_file.writelines("func name():\n")
    gd_file.writelines("\treturn '%s'\n" % protocol_name)
    gd_file.writelines("\n")

    # id
    gd_file.writelines("func id():\n")
    gd_file.writelines("\treturn %d\n" % id)

    # length
    length = 0
    strings = ''
    for key in data.keys():
        if data[key]=='int':
            length += 4
        if data[key]=='long':
            length += 8
        if data[key]=='float':
            length += 4
        if data[key]=='string':
            length += 4
            strings += "+" + key + ".length()" 

    gd_file.writelines("\n")
    gd_file.writelines("func length():\n")
    gd_file.writelines("\treturn %d %s;\n" % (length, strings))
    gd_file.writelines("\n")

    # send data
    gd_file.writelines("func send(stream):\n")
    gd_file.writelines("\tvar buf = ByteBuf.new()\n")
    gd_file.writelines("\tbuf.write_i32(int(id()))\n")
    gd_file.writelines("\tbuf.write_i32(int(length()))\n")
    for key in data.keys():
        if data[key]=='int':
            gd_file.writelines("\tbuf.write_i32(%s)\n" % key)
        if data[key]=='long':
            gd_file.writelines("\tbuf.write_i64(%s)\n" % key)
        if data[key]=='float':
            gd_file.writelines("\tbuf.write_float(%s)\n" % key)
        if data[key]=='string':
            gd_file.writelines("\tbuf.write_string(%s)\n" % key)

    gd_file.writelines("\tbuf.write_byte(64)\n")
    gd_file.writelines("\tbuf.write_byte(64)\n")
    gd_file.writelines("\tstream.put_data(buf.raw_data())")
    gd_file.writelines("\n")

    # parse data
    gd_file.writelines("\n")
    gd_file.writelines("func parse_data( byteBuffer):\n")
    for key in data.keys():
        if data[key]=='int':
            gd_file.writelines("\t%s = byteBuffer.read_i32();\n" % key)
        if data[key]=='long':
            gd_file.writelines("\t%s = byteBuffer.read_i64();\n" % key)
        if data[key]=='float':
            gd_file.writelines("\t%s = byteBuffer.read_float();\n" % key)
        if data[key]=='string':
            gd_file.writelines("\t%s = byteBuffer.read_string();\n" % key)

    gd_file.writelines("\tpass\n")

    gd_file.close()

    print("generate " + gd_file_name + " succeed")


def generate_msg_jave_base_class():
    java_file_name = java_save_path + "message.java"
    java_file = open(java_file_name, "w+")
    java_file.writelines("package protocol;\n\n")
    java_file.writelines("import io.netty.buffer.ByteBuf;\n")
    java_file.writelines("import io.netty.buffer.Unpooled;\n\n")
    java_file.writelines("public class message {\n\n")

    # get_id
    java_file.writelines("\tpublic int id(){\n")
    java_file.writelines("\t\t return %d;\n" % 0)
    java_file.writelines("\t}\n")

    # length
    java_file.writelines("\n")
    java_file.writelines("\tpublic int length(){\n")
    java_file.writelines("\t\t return %d;\n" % 0)
    java_file.writelines("\t}\n")

    # pass data
    java_file.writelines("\n")
    java_file.writelines("\tpublic void parse_data(ByteBuf byteBuffer){\n")
    java_file.writelines("\t\tSystem.out.println(\"parse_data method hasn't implementation.\");\n")
    java_file.writelines("\t}\n")

    # write string
    java_file.writelines("\n")
    java_file.writelines("\tpublic void write_string(ByteBuf byteBuffer, String str){\n")
    java_file.writelines("\t\tbyteBuffer.writeInt(str.length());\n")
    java_file.writelines("\t\tbyteBuffer.writeBytes(str.getBytes());\n")
    java_file.writelines("\t}\n")

    # read string
    java_file.writelines("\n")
    java_file.writelines("\tpublic String read_string(ByteBuf byteBuffer){\n")
    java_file.writelines("\t\tint length = byteBuffer.readInt();\n")
    java_file.writelines("\t\tbyte[] result = new byte[length];\n");
    java_file.writelines("\t\tfor(int i=0; i<length; i++){\n")
    java_file.writelines("\t\t\tresult[i] = byteBuffer.readByte();\n")
    java_file.writelines("\t\t}\n")
    #java_file.writelines("\t\tresult[length] = '\\0';\n")
    java_file.writelines("\t\treturn new String(result);\n")
    java_file.writelines("\t}\n")

    # end
    java_file.writelines("}\n")
    java_file.close()

generate_msg_jave_base_class()

dirs = os.listdir(root_path)
id = 1
for file in dirs:
    if os.path.splitext(file)[1] == '.proto':
        gen_protocol_java( file, id)
        gen_protocol_godot(file, id)
        id+=1
