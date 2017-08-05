#ifndef GOMOB_H
#define GOMOB_H

#include "reference.h"

class Gomob : public Reference {
    OBJ_TYPE(Gomob,Reference);

    String adsId;
    bool bottom;
    bool test;

    bool initialized;

protected:
    static void _bind_methods();

public:

    void init(const String &adsId);
    void set_test(bool val);
    void set_top(bool val);
    void set_bottom(bool val);
    void show();
    void request_videoad();
    bool is_videoad_ready();
    void show_videoad();

    Gomob();
    ~Gomob();
};

#endif
