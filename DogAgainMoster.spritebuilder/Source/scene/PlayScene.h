//
//  PlayScene.h
//  DogAgainMoster
//
//  Created by mybox_1027@sina.com on 14-3-30.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayScene : CCNode
{
    CCSprite *m_spriteBall;   
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;


@end
