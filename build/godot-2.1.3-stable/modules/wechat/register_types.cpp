#include "register_types.h"
#include "object_type_db.h"
#include "core/globals.h"
#include "ios/src/wechat.h"

void register_wechat_types() {
    Globals::get_singleton()->add_singleton(Globals::Singleton("WeChat", memnew(WeChat)));
}

void unregister_wechat_types() {
}
