//
//  GameObject.h
//  CocosDragon
//
//  Created by mybox_1027@sina.com on 13-5-28.
//
//

#import "CCNode.h"

@interface GameObject : CCNode
{
    BOOL isScheduleForRemove;
}

@property (nonatomic,assign)BOOL isScheduleForRemove;
@property (nonatomic,readonly)float radius;

-(void)update;
-(void)handleCollisionWith:(GameObject*)gameObject;
@end
