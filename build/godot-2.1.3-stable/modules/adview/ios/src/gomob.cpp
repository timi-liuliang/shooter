#include "gomob.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

Gomob* instance = NULL;

Gomob::Gomob() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
    test = true;
    bottom = true;
    //Kamil
    //ors
}

Gomob::~Gomob() {
    instance = NULL;
}

void Gomob::init(const String &adsId) {
  this->adsId = adsId;
}

void Gomob::set_test(bool val) {
  this->test = val;
}

void Gomob::set_top(bool val) {
  this->bottom = !val;
  this->abc = true;
}

void Gomob::set_bottom(bool val) {
  this->bottom = val;
}

void Gomob::show() {
}

void Gomob::_bind_methods() {
    ObjectTypeDB::bind_method("init",&Gomob::init);
    ObjectTypeDB::bind_method("set_test",&Gomob::set_test);
    ObjectTypeDB::bind_method("set_top",&Gomob::set_top);
    ObjectTypeDB::bind_method("set_bottom",&Gomob::set_bottom);
    ObjectTypeDB::bind_method("show",&Gomob::show);
}
