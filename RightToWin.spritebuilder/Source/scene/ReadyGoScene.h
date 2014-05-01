//
//  ReadyGoScene.h
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-4-30.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "../obj/BlockObj.h"

@interface ReadyGoScene : CCNode<CCBAnimationManagerDelegate>
{
    BlockObj *m_blockObj;
}

- (void)completedAnimationSequenceNamed:(NSString*)name;


@end
