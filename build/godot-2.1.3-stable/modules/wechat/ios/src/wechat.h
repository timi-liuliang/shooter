#ifndef WECHAT_H
#define WECHAT_H

#include "reference.h"

class WeChat : public Reference {
    OBJ_TYPE(WeChat,Reference);

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

    WeChat();
    ~WeChat();
};

#endif
