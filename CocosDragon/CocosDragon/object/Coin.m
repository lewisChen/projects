//
//  Coin.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-29.
//
//

#import "Coin.h"
#import "Dragon.h"
#import "GameScene.h"
#include "SimpleAudioEngine.h"

@implementation Coin

@synthesize isEndCoin;

-(void)handleCollisionWith:(GameObject *)gameObject
{
    if ([gameObject isKindOfClass:[Dragon class]])
    {
        if (isEndCoin)
        {
            //Level is complete
            [[GameScene sharedScene] handleLevelComplete];
        }
        self.isScheduleForRemove = YES;
        [[SimpleAudioEngine sharedEngine] playEffect:@"22k_viking_swingingV3.wav"];
    }
}

-(float)radius
{
    return 15;
}

@end
