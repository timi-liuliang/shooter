#include "register_types.h"
#include "object_type_db.h"
#include "core/globals.h"
#include "ios/src/easyar.h"

void register_easyar_types() {
    Globals::get_singleton()->add_singleton(Globals::Singleton("EasyAr", memnew(EasyAr)));
}

void unregister_easyar_types() {
}
