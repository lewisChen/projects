//
//  PlayScene.h
//  DogAgainMoster
//
//  Created by mybox_1027@sina.com on 14-3-30.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface PlayScene : CCNode<CCPhysicsCollisionDelegate>
{
    CCSprite *m_background;
    
    CCPhysicsNode *m_physicsNodeWorld;
    
    CCSprite *m_spriteBall;
    CCSprite *m_buttomBody;
    CCNode *m_mouseJointNode;
    CCPhysicsJoint *m_mouseJoint;
    
    CCPhysicsJoint *m_jointLeft;
    CCPhysicsJoint *m_jointRight;
    
    CCSprite *m_objLeftPin;
    CCSprite *m_objMiddlePin;
    CCSprite *m_objRightPin;
    
    CGPoint m_pointAim;
    CGPoint m_startPosition;
    
}

@property(readwrite)CGPoint aimPoint;
@property(readwrite)CGPoint startPosition;

- (void)releaseJoint;
- (void)initWeapon;
- (void)resetWeapon;
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)drawLine;
- (void)draw;
- (void)update:(CCTime)delta;

@end
