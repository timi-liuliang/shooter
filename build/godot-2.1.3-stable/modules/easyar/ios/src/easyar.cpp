#include "easyar.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

static EasyAr* instance = NULL;

EasyAr::EasyAr() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
    test = true;
    bottom = true;
    //Kamil
    //ors
}

EasyAr::~EasyAr() {
    instance = NULL;
}

void EasyAr::init(const String &adsId) {
  this->adsId = adsId;
}

void EasyAr::set_test(bool val) {
  this->test = val;
}

void EasyAr::set_top(bool val) {
  this->bottom = !val;
  this->abc = true;
}

void EasyAr::set_bottom(bool val) {
  this->bottom = val;
}

void EasyAr::show() {
}

void EasyAr::_bind_methods() {
    ObjectTypeDB::bind_method("init",&EasyAr::init);
    ObjectTypeDB::bind_method("set_test",&EasyAr::set_test);
    ObjectTypeDB::bind_method("set_top",&EasyAr::set_top);
    ObjectTypeDB::bind_method("set_bottom",&EasyAr::set_bottom);
    ObjectTypeDB::bind_method("show",&EasyAr::show);
}
