#ifndef BYTE_BUF_H
#define BYTE_BUF_H

#include <reference.h>
#include <dvector.h>
#include <io/stream_peer.h>

// C++ wrapper for ByteBuf
class ByteBuf : public Reference 
{
    OBJ_TYPE(ByteBuf, Reference)

public:
    ByteBuf();
    ~ByteBuf();

	void write_byte(uint8_t p_val);
    void write_i32(int32_t p_val);
    int32_t read_i32();

	void write_float(float p_val);
	float read_float();

	DVector<uint8_t>& raw_data();

protected:
    static void _bind_methods();

    int     readIdx;
    int     writeIdx;
	DVector<uint8_t> data;
};

#endif // OPENSIMPLEX_NOISE_H


