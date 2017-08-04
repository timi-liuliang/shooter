#include "adview.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

AdView* instance = NULL;

AdView::AdView() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
    test = true;
    bottom = true;
    //Kamil
    //ors
}

AdView::~AdView() {
    instance = NULL;
}

void AdView::init(const String &adsId) {
  this->adsId = adsId;
}

void AdView::set_test(bool val) {
  this->test = val;
}

void AdView::set_top(bool val) {
  this->bottom = !val;
  this->abc = true;
}

void AdView::set_bottom(bool val) {
  this->bottom = val;
}

void AdView::show() {
}

void AdView::_bind_methods() {
    ObjectTypeDB::bind_method("init",&AdView::init);
    ObjectTypeDB::bind_method("set_test",&AdView::set_test);
    ObjectTypeDB::bind_method("set_top",&AdView::set_top);
    ObjectTypeDB::bind_method("set_bottom",&AdView::set_bottom);
    ObjectTypeDB::bind_method("show",&AdView::show);
}
