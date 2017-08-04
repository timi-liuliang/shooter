#include "register_types.h"
#include "object_type_db.h"
#include "core/globals.h"
#include "ios/src/adview.h"

void register_adview_types() {
    Globals::get_singleton()->add_singleton(Globals::Singleton("AdView", memnew(AdView)));
}

void unregister_adview_types() {
}
