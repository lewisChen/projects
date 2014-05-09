//
//  ReadyGoScene.m
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-4-30.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "ReadyGoScene.h"
#import "../Def/SoundDef.h"
#include "../libs/cocos2d-iphone/external/ObjectAL/OALSimpleAudio.h"
#import "../DataHandler/GameDataHandler.h"
#import "../AppDelegate.h"


@implementation ReadyGoScene

- (void) didLoadFromCCB
{
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectBeep];
    
    // the animation manager of each node is stored in the 'userObject' property
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"readyAmination"];
    
    [m_blockObj setType:[GameDataHandler sharedGameDataHandler].blockTypeSelect];
    
//    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
//    [notiCenter postNotificationName:kHideAdMessage object:nil];
}

-(void)completedAnimationSequenceNamed:(NSString *)name
{
    if ([name isEqualToString:@"readyAmination"])
    {
        [[OALSimpleAudio sharedInstance] playEffect:kEffectBeep];
        CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
    }
}

@end
