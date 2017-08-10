#include "gomob.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

static Gomob* instance = NULL;

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
}

void Gomob::set_bottom(bool val) {
  this->bottom = val;
}

void Gomob::show() {
}

void Gomob::request_videoad(){

}

bool Gomob::is_videoad_ready(){
  return false;
}

void Gomob::show_videoad(){

}

void Gomob::signal_reward_videoad(const String& type, real_t amount)
{}

void Gomob::_bind_methods() {
    ObjectTypeDB::bind_method("init",&Gomob::init);
    ObjectTypeDB::bind_method("set_test",&Gomob::set_test);
    ObjectTypeDB::bind_method("set_top",&Gomob::set_top);
    ObjectTypeDB::bind_method("set_bottom",&Gomob::set_bottom);
    ObjectTypeDB::bind_method("show",&Gomob::show);
    ObjectTypeDB::bind_method("request_videoad",&Gomob::request_videoad);
    ObjectTypeDB::bind_method("show_videoad",&Gomob::show_videoad);

    ADD_SIGNAL(MethodInfo("reward_based_videoad", PropertyInfo(Variant::STRING, "type"), PropertyInfo(Variant::REAL, "amount")));
}
