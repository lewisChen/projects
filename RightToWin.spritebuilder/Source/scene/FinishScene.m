//
//  FinishScene.m
//  Tap Right Tile to Win
//
//  Created by mybox_1027@sina.com on 14-4-28.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "FinishScene.h"
#import "../DataHandler/GameDataHandler.h"
#import "../Def/SoundDef.h"


@implementation FinishScene

- (void) didLoadFromCCB
{
    GameDataHandler *dataHandle = [GameDataHandler sharedGameDataHandler];
    eGameMode mode = dataHandle.gameMode;
    switch (mode)
    {
        case eGameModeTime:
            m_labelTime.visible = YES;
            m_lableCount.visible = NO;
            m_lableCrazy.visible = NO;
            break;
        case eGameModeCount:
            m_labelTime.visible = NO;
            m_lableCount.visible = YES;
            m_lableCrazy.visible = NO;
            break;
        case eGameModeCrazy:
            m_labelTime.visible = NO;
            m_lableCount.visible = NO;
            m_lableCrazy.visible = YES;
            break;
        default:
            break;
    }
    
    [m_blockObj setType:(eBlockType)dataHandle.blockTypeSelect];
    [[OALSimpleAudio sharedInstance] preloadEffect:kEffectTouched];
    [m_labelTapCount setString:[NSString stringWithFormat:@"%d",dataHandle.tapCount]];
}

-(void)buttonPress:(id)sender
{
    if (m_buttonRetry == sender)
    {
        CCScene *scene = [CCBReader loadAsScene:@"PlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
    }
    else if(m_buttonBack == sender)
    {
        CCScene *scene = [CCBReader loadAsScene:@"StartPlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
    }
    [[OALSimpleAudio sharedInstance] playEffect:kEffectTouched];
}


@end
