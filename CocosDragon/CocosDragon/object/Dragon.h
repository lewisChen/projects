//
//  Dragon.h
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-28.
//
//

#import "GameObject.h"

#define kCJStartSpeed 8
#define kCJCoinSpeed 8
#define kCJStartTarget 160
#define kCJTargetFilterFactor 0.05
#define kCJSlowDownFactor 0.995
#define kCJGravitySpeed 0.1
#define kCJGameOverSpeed -10
#define kCJDeltaToRotationFactor 5

@interface Dragon : GameObject
{
    float ySpeed;
    float xTarget;
}

@property(nonatomic,assign)float xTarget;

@end
