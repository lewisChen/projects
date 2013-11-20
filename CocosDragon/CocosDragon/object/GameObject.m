//
//  GameObject.m
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-28.
//
//

#import "GameObject.h"

@implementation GameObject

@synthesize isScheduleForRemove;
//update is called for every game object once every frame
-(void)update
{
    
}

//If this game object has collied with another game object this method is called
-(void)handleCollisionWith:(GameObject *)gameObject
{
    
}

//Return the radius of the game object
-(float)radius
{
    return 0;
}
@end
