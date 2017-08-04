#ifndef EASYAR_H
#define EASYAR_H

#include "reference.h"

class EasyAr : public Reference {
    OBJ_TYPE(EasyAr,Reference);

    String adsId;
    bool bottom;
    bool test;

    bool initialized;

    bool abc;

protected:
    static void _bind_methods();

public:

    void init(const String &adsId);
    void set_test(bool val);
    void set_top(bool val);
    void set_bottom(bool val);
    void show();

    EasyAr();
    ~EasyAr();
};

#endif
