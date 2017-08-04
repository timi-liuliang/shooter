#include "gomob.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

#import <GoogleMobileAds/DFPBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import <UIKit/UIKit.h>

#import "app_delegate.h"

WeChat* instance = NULL;

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
  if(!initialized) {
    DFPBannerView *bannerView_ = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];

    if(test) {
      bannerView_.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    }
    else {
      bannerView_.adUnitID = [NSString stringWithCString:adsId.utf8().get_data() encoding:NSUTF8StringEncoding];
    }

    NSLog(@"adUnitID: %@", bannerView_.adUnitID);

    ViewController * root_controller = (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;


    bannerView_.rootViewController = root_controller;


    GADRequest *request = [GADRequest request];

    request.testDevices = @[ @"2077ef9a63d2b398840261c8221a0c9a"];
    [bannerView_ loadRequest:request];

    if(bottom) {
      float height = root_controller.view.frame.size.height;
      float width = root_controller.view.frame.size.width;
      NSLog(@"height: %f, width: %f", height, width);
      [bannerView_ setFrame:CGRectMake(0, height-bannerView_.bounds.size.height, bannerView_.bounds.size.width, bannerView_.bounds.size.height)];
    }

    [root_controller.view addSubview:bannerView_];
    initialized = true;
  }
}

void WeChat::_bind_methods() {
    ObjectTypeDB::bind_method("init",&WeChat::init);
    ObjectTypeDB::bind_method("set_test",&WeChat::set_test);
    ObjectTypeDB::bind_method("set_top",&WeChat::set_top);
    ObjectTypeDB::bind_method("set_bottom",&WeChat::set_bottom);
    ObjectTypeDB::bind_method("show",&WeChat::show);
}
