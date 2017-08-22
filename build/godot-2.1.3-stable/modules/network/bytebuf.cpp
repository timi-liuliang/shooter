#include "bytebuf.h"
#include <io/marshalls.h>

ByteBuf::ByteBuf() : Reference(), readIdx(0), writeIdx(0){

}

ByteBuf::~ByteBuf() {
}

void ByteBuf::write_byte(uint8_t p_val)
{
	data.push_back(p_val);
	writeIdx += 1;
}

uint8_t ByteBuf::read_byte()
{
	uint8_t * buf = &(data.write().ptr()[readIdx]);
	readIdx += 1;

	return buf[0];
}

void ByteBuf::write_i32(int32_t p_val)
{
	//big_endian
	data.resize(data.size()+4);
	p_val = BSWAP32(p_val);
	encode_uint32(p_val, &(data.write().ptr()[writeIdx]));
	writeIdx += 4;
}

int32_t ByteBuf::read_i32()
{
	uint32_t r = decode_uint32(&(data.write().ptr()[readIdx]));
	r = BSWAP32(r);
	readIdx += 4;

	return r;
}

void ByteBuf::write_i64(int64_t p_val)
{
	//big_endian
	data.resize(data.size()+8);
	p_val = BSWAP64(p_val);
	encode_uint64(p_val, &(data.write().ptr()[writeIdx]));
	writeIdx += 8;
}

int64_t ByteBuf::read_i64()
{
	uint64_t r = decode_uint64(&(data.write().ptr()[readIdx]));
	r = BSWAP64(r);
	readIdx += 8;

	return r;
}

void ByteBuf::write_float(float p_val) {

	data.resize(data.size() + 4);
	encode_float(p_val, &(data.write().ptr()[writeIdx]));
	if (true) {
		uint32_t *p32 = (uint32_t *)&(data.write().ptr()[writeIdx]);
		*p32 = BSWAP32(*p32);
	}

	writeIdx += 4;
}

float ByteBuf::read_float() {
	uint8_t * buf = &(data.write().ptr()[readIdx]);
	if (true) {
		uint32_t *p32 = (uint32_t *)buf;
		*p32 = BSWAP32(*p32);
	}

	float r = decode_float(buf);
	readIdx += 4;
	return r;
}

void ByteBuf::write_string(const String& str)
{
	int size = str.length();
	write_i32(size);

	for(int i=0; i<size; i++)
		write_byte(str[i]);
}
    
String ByteBuf::read_string()
{
	char result[2048];

	int32_t size = read_i32();
	for(int i=0; i<size; i++)
		result[i] = read_byte();

	result[size] = '\0';

	return result;
}

DVector<uint8_t>& ByteBuf::raw_data()
{
	return data;
}

void ByteBuf::_bind_methods() 
{
	ObjectTypeDB::bind_method(_MD("write_byte", "byte"), &ByteBuf::write_byte);
    ObjectTypeDB::bind_method(_MD("write_i32", "value"), &ByteBuf::write_i32);
	ObjectTypeDB::bind_method(_MD("read_i32"), &ByteBuf::read_i32);
	ObjectTypeDB::bind_method(_MD("write_i64", "value"), &ByteBuf::write_i64);
	ObjectTypeDB::bind_method(_MD("read_i64"), &ByteBuf::read_i64);
	ObjectTypeDB::bind_method(_MD("write_float", "value"), &ByteBuf::write_float);
	ObjectTypeDB::bind_method(_MD("read_float"), &ByteBuf::read_float);
	ObjectTypeDB::bind_method(_MD("write_string", "value"), &ByteBuf::write_string);
	ObjectTypeDB::bind_method(_MD("read_string"), &ByteBuf::read_string);
    ObjectTypeDB::bind_method(_MD("raw_data"), &ByteBuf::raw_data);
}
