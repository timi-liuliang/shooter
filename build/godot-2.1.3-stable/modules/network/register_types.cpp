#include "register_types.h"
#include "bytebuf.h"

void register_network_types() 
{
    ObjectTypeDB::register_type<ByteBuf>();
}

void unregister_network_types() 
{

}

