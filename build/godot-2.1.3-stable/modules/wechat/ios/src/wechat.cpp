#include "wechat.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

static WeChat* instance = NULL;

WeChat::WeChat() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
    test = true;
    bottom = true;
    //Kamil
    //ors
}

WeChat::~WeChat() {
    instance = NULL;
}

void WeChat::init(const String &adsId) {
  this->adsId = adsId;
}

void WeChat::set_test(bool val) {
  this->test = val;
}

void WeChat::set_top(bool val) {
  this->bottom = !val;
  this->abc = true;
}

void WeChat::set_bottom(bool val) {
  this->bottom = val;
}

void WeChat::show() {
}

void WeChat::_bind_methods() {
    ObjectTypeDB::bind_method("init",&WeChat::init);
    ObjectTypeDB::bind_method("set_test",&WeChat::set_test);
    ObjectTypeDB::bind_method("set_top",&WeChat::set_top);
    ObjectTypeDB::bind_method("set_bottom",&WeChat::set_bottom);
    ObjectTypeDB::bind_method("show",&WeChat::show);
}
