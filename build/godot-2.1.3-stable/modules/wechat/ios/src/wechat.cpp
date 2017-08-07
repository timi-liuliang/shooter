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

void WeChat::_bind_methods() {
    ObjectTypeDB::bind_method("init",&WeChat::init);
    ObjectTypeDB::bind_method("send_msg",&WeChat::send_msg);
}
