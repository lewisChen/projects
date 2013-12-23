//
//  AppDelegate.h
//  NumberPuzzleBeta2
//
//  Created by mybox_1027@sina.com on 13-12-3.
//  Copyright mybox_1027@sina.com 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#include "GADBannerView.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
    GADBannerView *m_admobView;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic,retain) GADBannerView *adView;

@end
