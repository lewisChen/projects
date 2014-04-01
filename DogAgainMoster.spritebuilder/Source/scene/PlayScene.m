//
//  PlayScene.m
//  DogAgainMoster
//
//  Created by mybox_1027@sina.com on 14-3-30.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "PlayScene.h"


@implementation PlayScene

- (void) didLoadFromCCB
{
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    //[[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}


-(void)backButton:(id)sender
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    m_spriteBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    m_spriteBall.physicsBody.type = CCPhysicsBodyTypeStatic;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
