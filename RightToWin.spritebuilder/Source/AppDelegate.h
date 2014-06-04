/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "cocos2d.h"
//#import "admob/GADInterstitial.h"
#include "admob/GADBannerView.h"

#define kShowAdMessage (@"kShowAdMessage")
#define kHideAdMessage (@"kHideAdMessage")

#define appId (869242710)


@interface AppController : CCAppDelegate<GADBannerViewDelegate>
{
    GADBannerView *m_admobView;
    //GADInterstitial *m_admobView;

}

//- (void)interstitialDidReceiveAd:(GADInterstitial *)ad;

@property (nonatomic,retain) GADBannerView *adView;

- (void)registerAdMessage;
- (void)registerShareSdk;
- (void)showAdView;
- (void)hideAdView;
//GADBannerViewDelegate
-(void)adViewDidReceiveAd:(GADBannerView *)view;

@end
