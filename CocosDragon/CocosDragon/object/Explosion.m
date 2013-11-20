//
//  Explosion.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-30.
//
//

#import "Explosion.h"

@implementation Explosion

- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

-(void)completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    self.isScheduleForRemove = YES;
}


@end
