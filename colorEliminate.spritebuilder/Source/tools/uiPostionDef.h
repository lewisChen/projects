//
//  uiPostionDef.h
//  NumberPuzzle
//
//  Created by mybox_1027@sina.com on 14-3-23.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#ifndef NumberPuzzle_uiPostionDef_h
#define NumberPuzzle_uiPostionDef_h

#import "../admob/GADAdSize.h"

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height -(double)568)<DBL_EPSILON)
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568)<DBL_EPSILON)
#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_IPHONE_SIMULATOR ([[[UIDevice currentDevice]mode] isEqualToString:@"iPhone Simulator"])
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

inline static CGPoint getUiPosition(CGPoint pos)
{
    CGPoint convertPos = CGPointZero;
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    
    if (IS_IPHONE_5)
    {
        convertPos = pos;
    }
    else
    {
        convertPos.x = pos.x;
        convertPos.y = pos.y*568/winSize.height;
    }
    
    return convertPos;
}

inline static CGSize getAdSize(void)
{
    CGSize adSize = kGADAdSizeBanner.size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        adSize = kGADAdSizeLeaderboard.size;

    }
    return adSize;
}

#endif
