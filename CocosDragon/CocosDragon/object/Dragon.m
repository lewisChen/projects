//
//  Dragon.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-28.
//
//

#import "Dragon.h"
#import "Coin.h"
#import "Bomb.h"
#import "GameScene.h"
#import "CCBAnimationManager.h"

@implementation Dragon

@synthesize xTarget;

-(id)init
{
    self = [super init];
    if (!self)
    {
        return NULL;
    }
    xTarget = kCJStartTarget;
    ySpeed = kCJStartSpeed;
    return self;
}

-(void)update
{
    //calculate new position
    CGPoint oldPosition = self.position;
    float xNew = xTarget*kCJTargetFilterFactor + oldPosition.x *(1-kCJTargetFilterFactor);
    float yNew = oldPosition.y+ySpeed;
    self.position = ccp(xNew, yNew);
    //Update the vertical speed
    ySpeed = (ySpeed-kCJGravitySpeed)*kCJSlowDownFactor;
    //Tilt the dragon depending on horizontal speed
    float xDelta = xNew-oldPosition.x;
    self.rotation = xDelta*kCJDeltaToRotationFactor;
    //check for game over
    if (ySpeed<kCJGameOverSpeed)
    {
        [[GameScene sharedScene] handleGameOver];
    }
}


-(void)handleCollisionWith:(GameObject *)gameObject
{
    if ([gameObject isKindOfClass:[Coin class]])
    {
        //Took a coin
        ySpeed = kCJCoinSpeed;
        [GameScene sharedScene].score +=1;
    }
    else if([gameObject isKindOfClass:[Bomb class]])
    {
        //hit a bomb
        if (ySpeed>0)
        {
            ySpeed =0;
        }
        CCBAnimationManager *animationManager = self.userObject;//??
        NSLog(@"animationManager:%@",animationManager);
        [animationManager runAnimationsForSequenceNamed:@"hit"];
    }
}
-(float)radius
{
    return 25;
}
@end
