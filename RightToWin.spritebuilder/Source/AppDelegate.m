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

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"

@interface AppController ()
@property CGSize _Adsize;
@end

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self._Adsize = kGADAdSizeBanner.size;
    }
    else
    {
        self._Adsize = kGADAdSizeLeaderboard.size;
    }
    
    [self registerAdMessage];
    
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    m_admobView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,winSize.height, self._Adsize.width, self._Adsize.height)];
    m_admobView.center = ccp(winSize.width/2, m_admobView.center.y);
    m_admobView.adUnitID = @"a15355d8e0b278a";
    m_admobView.delegate = self;
    m_admobView.rootViewController = navController_;
    [[[window_ rootViewController] view] addSubview:m_admobView];
    
    [m_admobView loadRequest:[GADRequest request]];
    
//    m_admobView = [[GADInterstitial alloc] init];
//    m_admobView.adUnitID = @"a15355d8e0b278a";
//    [m_admobView loadRequest:[GADRequest request]];
//    m_admobView.delegate = self;

    
    return YES;
}

- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}

- (void) delete:(id)sender
{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self name:kShowAdMessage object:nil];
    
    [self delete:m_admobView];
}

//-(void)interstitialDidReceiveAd:(GADInterstitial *)ad
//{
//    [m_admobView presentFromRootViewController:window_.rootViewController];
//}

-(void)registerAdMessage
{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(showAdView) name:kShowAdMessage object:nil];
    [notiCenter addObserver:self selector:@selector(hideAdView) name:kHideAdMessage object:nil];

}

-(void)showAdView
{
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.2
                     animations:^{m_admobView.frame = CGRectMake(0.0,winSize.height-self._Adsize.height, self._Adsize.width, self._Adsize.height);
                                  m_admobView.center = ccp(winSize.width/2, m_admobView.center.y);
                                    }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.0
                                               delay:5
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^{m_admobView.frame = CGRectMake(0.0,winSize.height, self._Adsize.width, self._Adsize.height);}
                                          completion:^(BOOL finish){}];
                     }];

    //[m_admobView loadRequest:[GADRequest request]];
}


-(void)hideAdView
{
    m_admobView.frame = CGRectMake(0.0,[CCDirector sharedDirector].viewSize.height, self._Adsize.width,self._Adsize.height);
}

-(void)adViewDidReceiveAd:(GADBannerView *)view
{
//    CGSize winSize = [[UIScreen mainScreen] bounds].size;
//    
//    [UIView animateWithDuration:0.2
//                     animations:^{m_admobView.frame = CGRectMake(0.0,winSize.height-self._Adsize.height, self._Adsize.width, self._Adsize.height);}
//                     completion:^(BOOL finished){
//                                                    [UIView animateWithDuration:0.0
//                                                        delay:5
//                                                        options:UIViewAnimationOptionTransitionNone
//                                                        animations:^{m_admobView.frame = CGRectMake(0.0,winSize.height, self._Adsize.width, self._Adsize.height);}
//                                                        completion:^(BOOL finish){}];
//                                                }];
    
}

@end
