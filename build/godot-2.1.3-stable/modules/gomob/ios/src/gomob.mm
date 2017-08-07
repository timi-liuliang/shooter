#include "gomob.h"
#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"

#import <GoogleMobileAds/DFPBannerView.h>
#import <GoogleMobileAds/GADRewardBasedVideoAd.h>
#import <GoogleMobileAds/GADRequest.h>
#import <GoogleMobileAds/GADAdReward.h>
#import <GoogleMobileAds/GADRewardBasedVideoAdDelegate.h>

#import <UIKit/UIKit.h>

#import "app_delegate.h"

static Gomob* instance = NULL;

@interface ReawardDelegate<GADRewardBasedVideoAdDelegate> : NSObject
@end

@implementation ReawardDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didRewardUserWithReward:(GADAdReward *)reward{
  NSString *rewardMessage =
      [NSString stringWithFormat:@"Reward received with type %@ , amount %lf",
          reward.type,
          [reward.amount doubleValue]];
  NSLog(rewardMessage);

  if(instance){
    NSLog(@"Reward received signal emitted to GDScript.");
    const char* type = [reward.type UTF8String];
    instance->signal_reward_videoad( type,[reward.amount doubleValue]);
  }
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
  NSLog(@"Reward based video ad is received.");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
  NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
  NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
  NSLog(@"Reward based video ad is closed.");
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
  NSLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
  NSLog(@"Reward based video ad failed to load.");
}
@end

Gomob::Gomob() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
    test = false;
    bottom = true;
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
  if(!is_videoad_ready())
  {
    NSString* adUnitID = @"ca-app-pub-3940256099942544/1712485313";
    if(!test) {
      adUnitID = [NSString stringWithCString:adsId.utf8().get_data() encoding:NSUTF8StringEncoding];
    }
 
    //[GADRewardBasedVideoAd sharedInstance].delegate = self;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:adUnitID];
  }
}

bool Gomob::is_videoad_ready(){
  return [[GADRewardBasedVideoAd sharedInstance] isReady];
}

void Gomob::show_videoad(){
  if (is_videoad_ready()) {
    if(![GADRewardBasedVideoAd sharedInstance].delegate){
      [GADRewardBasedVideoAd sharedInstance].delegate = [[ReawardDelegate alloc] init];
    }

    ViewController * root_controller = (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:root_controller];
  }
}

void Gomob::signal_reward_videoad(const String& type, real_t amount){
  emit_signal( "reward_based_videoad", type, amount);
}

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
