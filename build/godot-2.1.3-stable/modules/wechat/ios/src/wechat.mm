#include "wechat.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

#import <UIKit/UIKit.h>
#import "../lib/WXApi.h"

static WeChat* instance = NULL;

@interface WxApiHandler<WXApiDelegate> : NSObject
@end

@implementation WxApiHandler
-(void) onReq:(BaseReq*)req
{
  NSLog(@"WxApi delegate onReq.");
}

-(void) onResp:(BaseResp*)resp
{
  NSLog(@"WxApi delegate onResp.");
}
@end

WeChat::WeChat() {
  ERR_FAIL_COND(instance != NULL);
  instance = this;
}

WeChat::~WeChat() {
    //instance = NULL;
}

void WeChat::init(const String &appId) {
  [WXApi registerApp:[NSString stringWithCString:appId.utf8().get_data() encoding:NSUTF8StringEncoding]];
}

void WeChat::send_msg() {
  NSString *kLinkURL = @"http://www.albertlab.cn:8088/shooter/shooter.html";
  NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
  NSString *kLinkTitle = @"Shooter";
  NSString *kLinkDescription = @"到底是嫦娥抛弃了后裔还是后裔抛弃了嫦娥。";

  // 创建发送对象实例
  SendMessageToWXReq* sendReq = [[SendMessageToWXReq alloc] init];
  sendReq.bText = NO;  // use text
  sendReq.scene = 1;    // 0 = 好友列表 1 = 朋友圈 2 = 收藏

  // 创建分享内容对象
  WXMediaMessage *urlMessage = [WXMediaMessage message];
  urlMessage.title = kLinkTitle;//分享标题
  urlMessage.description = kLinkDescription;//分享描述
  //[urlMessage setThumbImage:[UIImage imageNamed:@"testImg"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小

  // 创建多媒体对象
  WXWebpageObject *webObj = [WXWebpageObject object];
  webObj.webpageUrl = kLinkURL;//分享链接

  // 完成发送对象实例
  urlMessage.mediaObject = webObj;
  sendReq.message = urlMessage;

  // 发送分享信息
  [WXApi sendReq:sendReq];
}

void WeChat::_bind_methods() {
    ObjectTypeDB::bind_method("init",&WeChat::init);
    ObjectTypeDB::bind_method("send_msg",&WeChat::send_msg);
}
