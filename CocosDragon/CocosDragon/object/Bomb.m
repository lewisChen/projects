//
//  Bomb.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-30.
//
//

#import "Bomb.h"
#import "CCBReader.h"
#import "Dragon.h"
#include "SimpleAudioEngine.h"

@implementation Bomb

- (void) handleCollisionWith:(GameObject *)gameObject
{
    if ([gameObject isKindOfClass:[Dragon class]])
    {
        // Collided with the dragon, remove object and add an explosion instead
        self.isScheduleForRemove = YES;
        CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
        explosion.position = self.position;
        [self.parent addChild:explosion];
        [[SimpleAudioEngine sharedEngine] playEffect:@"22k_viking_dyingV1.wav"];
    }
}

- (float) radius
{
    return 15;
}


@end
