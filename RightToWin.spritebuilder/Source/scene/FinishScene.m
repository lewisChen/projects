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
#import "../DataHandler/GameKitHelper.h"


@implementation FinishScene

- (void) didLoadFromCCB
{
    GameDataHandler *dataHandle = [GameDataHandler sharedGameDataHandler];
    eGameMode mode = dataHandle.gameMode;
    dataHandle.errorCount++;
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
    
    [self sumitScore];
}

-(void)buttonPress:(id)sender
{
    if (m_buttonRetry == sender)
    {
        CCScene *scene = [CCBReader loadAsScene:@"ReadyGoScene"];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
    else if(m_buttonBack == sender)
    {
        CCScene *scene = [CCBReader loadAsScene:@"StartPlayScene"];
        [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.5]];
    }
    [[OALSimpleAudio sharedInstance] playEffect:kEffectTouched];
}

-(void)sumitScore
{
    GameDataHandler *dataHandle = [GameDataHandler sharedGameDataHandler];
    eGameMode mode = dataHandle.gameMode;
    switch (mode)
    {
        case eGameModeTime:
            [[GameKitHelper sharedGameKitHelper] submitScore:dataHandle.tapCount category:kBoardIdentifierTimeMode];
            break;
        case eGameModeCount:
            [[GameKitHelper sharedGameKitHelper] submitScore:dataHandle.tapCount category:kBoardIdentifierCountMode];
            break;
        case eGameModeCrazy:
            [[GameKitHelper sharedGameKitHelper] submitScore:dataHandle.tapCount category:kBoardIdentifierCrazeMode];
            break;
        default:
            break;
    }

}

@end
