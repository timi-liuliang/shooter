#ifndef WECHAT_H
#define WECHAT_H

#include "reference.h"

class WeChat : public Reference {
    OBJ_TYPE(WeChat,Reference);

protected:
    static void _bind_methods();

public:
    void init(const String &appId);
    void send_msg();

    void on_resp(const int type, int errCode, const String& errMsg);

    WeChat();
    ~WeChat();
};

#endif
