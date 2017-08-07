#include "wechat.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

static WeChat* instance = NULL;

WeChat::WeChat() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
}

WeChat::~WeChat() {
    instance = NULL;
}

void WeChat::init(const String &appId) {
}

void WeChat::send_msg() {
}

void WeChat::on_resp(const int type, int errCode, const String& errMsg){
}

void WeChat::_bind_methods() {
    ObjectTypeDB::bind_method("init",&WeChat::init);
    ObjectTypeDB::bind_method("send_msg",&WeChat::send_msg);

     ADD_SIGNAL(MethodInfo("on_resp", PropertyInfo(Variant::INT, "type"), PropertyInfo(Variant::INT, "errCode"), PropertyInfo(Variant::STRING, "errStr")));
}
